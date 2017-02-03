namespace :eastmoney do
  desc "many managers info under one fund."
  task :manager_info_from_fund => [:environment] do
    sb ||= SpiderBase.new
    number = 0


    # Project.limit(3).each_with_index do |project, index|
    Project.where("id > ?", number).find_each.each_with_index do |project, index|
      code = project.code

      sb ||= SpiderBase.new

      url = "http://fund.eastmoney.com/f10/jjjl_#{code}.html"
      fetch_content = sb.page_for_url(url);
      puts "Fetch project #{code} data from #{url} =========== #{index}"

      doc = fetch_content.doc;


      fund_managers_dir = Rails.public_path.join("fund/eastmoney/managers")
      FileUtils::mkdir_p(fund_managers_dir)

      file_name_with_path = fund_managers_dir.join("#{code}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{project.id} #{code}"
      end
    end
  end
end
