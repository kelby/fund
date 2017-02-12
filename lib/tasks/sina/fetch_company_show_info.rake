namespace :sina do
  # 共 119，但实际是 118 支基金
  desc "Task description"
  task :fetch_company_show_info => [:dependent, :tasks] do
    Catalog.where(sina_code: [nil, ""]).count

    Catalog.where.not(sina_code: [nil, ""]).count


    sb = SpiderBase.new
    company_show_dir = Rails.public_path.join("company/sina/show")
    FileUtils::mkdir_p(company_show_dir)


    Catalog.where.not(sina_code: [nil, ""]).each_with_index do |catalog, index|
      # sina_info = catalog.catalog_sina_info

      # if sina_info.blank?
      #   sina_info = catalog.create_catalog_sina_info(catalog_sina_code: catalog.sina_code)
      # end


      sina_code = catalog.sina_code

      url = "http://finance.sina.com.cn/fund/company/#{sina_code}.shtml"

      fetch_content = sb.page_for_url(url);
      puts "Fetch company #{sina_code} data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      file_name_with_path = company_show_dir.join("#{sina_code}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{sina_code}, Exception #{e}"
        break
      end

    end
  end

  # 这支基金比较特殊，上述方式抓取不完全内容，所以特别处理
  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    index ||= 0

    catalog = Catalog.find_by sina_code: '80000095'


    sina_code = catalog.sina_code

    url = "http://finance.sina.com.cn/fund/company/#{sina_code}.shtml"

    fetch_content = browser.goto(url);
    puts "Fetch company #{sina_code} data from #{url} =========== #{index}"

    # doc = fetch_content.doc;

    file_name_with_path = company_show_dir.join("#{sina_code}.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{sina_code}, Exception #{e}"
    end
  end

  # 共 119，但实际是 118 支基金
  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    company_show_dir = Rails.public_path.join("company/sina/show")

    Catalog.where.not(sina_code: [nil, ""]).each_with_index do |catalog, index|
      sina_code = catalog.sina_code
      file_name_with_path = company_show_dir.join("#{sina_code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts "Company #{sina_code} info =========== #{index}"

      puts doc.css(".cortop").text
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    company_show_dir = Rails.public_path.join("company/sina/show")

    Catalog.where.not(sina_code: [nil, ""]).each_with_index do |catalog, index|
      sina_code = catalog.sina_code
      file_name_with_path = company_show_dir.join("#{sina_code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts "Company #{sina_code} info =========== #{index}"

      if doc.present? && doc.css(".cortop").blank?
        next
      end

      sina_info = catalog.catalog_sina_info

      if sina_info.blank?
        sina_info = catalog.create_catalog_sina_info(catalog_sina_code: catalog.sina_code)
      end

      puts "Company #{sina_code} header_info_ele 1=========== #{index}"
      header_info_ele = doc.css(".cortop")

      if header_info_ele.present?
        sina_info.header_info['cover'] = header_info_ele.css("img")[0].attr('src')
        sina_info.header_info['name_with_ltd'] = header_info_ele.css(".left").text.try(:strip)
        sina_info.header_info['kefu'] = header_info_ele.css(".right").text.try(:strip)
      end


      puts "Company #{sina_code} body_info_ele 2=========== #{index}"
      body_info_ele = doc.css("table").select{|table_ele| (table_ele.text =~ /企业属性/) && (table_ele.text =~ /董事长/) && (table_ele.text =~ /总经理/) }[0]

      if body_info_ele.present?
        body_info_ele.css("td").each do |td_ele|
          key = td_ele.children[0].text
          value = td_ele.css("span").text

          # puts key
          # puts value
          sina_info.body_info[key] = value
        end
      end

      puts "Company #{sina_code} table_info_ele 3=========== #{index}"
      table_info_ele = doc.css("table.no_btm").select{|table_ele| (table_ele.text =~ /公司名称/) && (table_ele.text =~ /成立时间/) && (table_ele.text =~ /公司地址/) }[0]

      if table_info_ele.present?
        table_info_ele.css("td").each_slice(2) do |key_value_ele|
          key_ele = key_value_ele.first
          value_ele = key_value_ele.last

          key = key_ele.text.try(:strip)
          value = value_ele.text.try(:strip)

          # puts key
          # puts value
          sina_info.table_info[key] = value
        end
      end

      # if sina_info.changed?
        sina_info.save
      # end

      puts doc.css(".cortop").text
    end
  end
end
