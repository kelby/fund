desc "Database related tasks"
namespace :database do
  desc "Convert to utf8mb4"
  task convert_to_utf8mb4: :environment do
    connection = ActiveRecord::Base.connection
    database = connection.current_database

    connection.execute "ALTER DATABASE `#{database}` CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;"
    puts "Converted #{database} character set"

    skip_tables = ["schema_migrations", "ar_internal_metadata"]

    # Change all tables
    connection.tables.each do |table|
      connection.columns(table).each do |column|
        if column.sql_type == "varchar(255)"
          puts "#{column.name} is varchar(255)"
          # Check for 255 indexed columns
          connection.indexes(table).each do |index|
            next if skip_tables.include?(table)

            if index.columns.include?(column.name)
              puts "#{column.name} has index, altering length..."
              sql = "ALTER TABLE #{table} CHANGE `#{column.name}` `#{column.name}` varchar(191)"
              sql << " NOT NULL" if not column.null
              sql << " DEFAULT '#{column.default}'" if column.default.present?
              sql << ';'
              connection.execute sql
              puts "...done!"
            end
          end
        end
      end

      puts "Converting 1 #{table}..."
      if skip_tables.include?(table)
      else
        connection.execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
      end
      puts "...#{table} converted!"

      connection.columns(table).each do |column|
        next if skip_tables.include?(table)

        if column.type == :string || column.type == :text
          puts "Converting 2 #{column.name}..."
          sql = "ALTER TABLE #{table} CHANGE `#{column.name}` `#{column.name}` #{column.sql_type} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
          sql << " NOT NULL" if not column.null
          sql << " DEFAULT '#{column.default}'" if column.default.present?
          sql << ';'
          connection.execute sql
          puts "...#{column.name} done!"
        end
      end

      puts "Repairing #{table}..."
      connection.execute "REPAIR TABLE #{table};"
      puts "...#{table} repaired!"
      puts "Optimizing #{table}..."
      connection.execute "OPTIMIZE TABLE #{table};"
      puts "...#{table} optimized!"
    end
  end
end
