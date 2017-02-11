namespace :sina do
  desc "fetch all fund show page from sina."
  task :fetch_funds_company => [:environment] do
    sina_fund_dir = Rails.public_path.join("fund/sina/show")
    FileUtils::mkdir_p(sina_fund_dir)

    sb ||= SpiderBase.new
    index ||= 0

    Project.where.not(code: [nil, ""]).each_with_index do |project, index|
      code = project.code

      url = "http://finance.sina.com.cn/fund/quotes/#{code}/bc.shtml"

      puts "want to fetch project #{code} from #{url} ========= #{index}"

      fetch_content = sb.page_for_url(url);

      doc = fetch_content.doc;




      file_name_with_path = sina_fund_dir.join("#{code}.html")


      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{code}, Exception #{e}"
      end
    end
  end
end
