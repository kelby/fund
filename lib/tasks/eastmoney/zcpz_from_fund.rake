namespace :eastmoney do
  desc "zcpz list from a fund"
  task :zcpz_from_fund => [:environment] do
    sb ||= SpiderBase.new
    number = 0

    no_found_projects = []

    # Project.limit(3).each_with_index do |project, index|
    Project.where("id > ?", number).find_each.each_with_index do |project, index|
      code = project.code

      sb ||= SpiderBase.new


      url = "http://fund.eastmoney.com/f10/zcpz_#{code}.html"
      fetch_content = sb.page_for_url(url);
      puts "Fetch project #{code} data from #{url} =========== #{index}"

      doc = fetch_content.doc;


      fund_zcpz_dir = Rails.public_path.join("fund/eastmoney/zcpz")
      FileUtils::mkdir_p(fund_zcpz_dir)

      file_name_with_path = fund_zcpz_dir.join("#{code}.html")

      if doc.css(".detail").blank?
        no_found_projects << "#{code}--#{project.name}"
        puts "=============Not Found #{project.id} #{code}"
        next
      end

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{project.id} #{code}"
      end
    end

    puts "以下 #{no_found_projects.size} 没有找到对应的资产配置页面\n"
    puts no_found_projects.join(', ')
  end
end