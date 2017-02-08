namespace :sina do
  desc "Task description"
  task :manager_show_info => [:dependent, :tasks] do
    sb = SpiderBase.new
    manager_dir = Rails.public_path.join("manager/sina/show_info")
    FileUtils::mkdir_p(manager_dir)


    Developer.count
    # => 1481

    Developer.where.not(sina_code: [nil, ""]).count
    # => 1416


    Developer.where.not(sina_code: [nil, ""]).find_each.with_index do |developer, index|
      sina_code = developer.sina_code

      url = "http://stock.finance.sina.com.cn/manager/view/mInfo.php?mid=#{sina_code}"

      fetch_content = sb.page_for_url(url);
      puts "Fetch developer #{developer.id} data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      file_name_with_path = manager_dir.join("#{sina_code}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{sina_code}, Exception #{e}"
        break
      end
    end

  end
end