namespace :sina do
  desc "some fund at eastmoney is 404, so fetch them from sina."
  task :fetch_funds_company => [:environment] do
    sina_fund_dir = Rails.public_path.join("fund/sina/show")
    FileUtils::mkdir_p(sina_fund_dir)

    sb ||= SpiderBase.new
    index ||= 0

    Project.where(catalog_id: [nil, ""]).each_with_index do |project, index|
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

  # 基金详情页有两种！
  desc "fix fund without company"
  task :fix_funds_company => [:environment] do
    sina_fund_dir = Rails.public_path.join("fund/sina/show")

    Project.where(catalog_id: [nil, ""]).each_with_index do |project, index|
      code = project.code
      file_name_with_path = sina_fund_dir.join("#{code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      fund_ele = doc.css(".fund_glr")

      if fund_ele.blank?
        nav_eles = doc.css(".hq-nav")

        fund_ele = nav_eles.css("li")[1]
      end

      if fund_ele.blank?
        next
      end

      company_url = fund_ele.css("a").attr('href').value

      company_code = company_url.split(/\/|\./)[-2]

      catalog = Catalog.find_by(sina_code: company_code)

      if catalog.present?
        project.update(catalog_id: catalog.id)
      end
    end
  end
end
