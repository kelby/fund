namespace :eastmoney do
  desc "Task description"
  task :fetch_company_show_info => [:dependent, :tasks] do
    Catalog.where(code: [nil, ""]).count

    Catalog.where.not(code: [nil, ""]).count


    sb = SpiderBase.new
    company_show_dir = Rails.public_path.join("company/eastmoney/show")
    FileUtils::mkdir_p(company_show_dir)


    Catalog.where.not(code: [nil, ""]).each_with_index do |catalog, index|
      code = catalog.code

      url = "http://fund.eastmoney.com/company/#{code}.html"

      fetch_content = sb.page_for_url(url);
      puts "Fetch company #{code} data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      file_name_with_path = company_show_dir.join("#{code}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{code}, Exception #{e}"
        break
      end

    end
  end

  desc "Task description"
  task :set_company_show_info => [:dependent, :tasks] do
    company_show_dir = Rails.public_path.join("company/eastmoney/show")

    Catalog.where.not(code: [nil, ""]).each_with_index do |catalog, index|
      code = catalog.code
      file_name_with_path = company_show_dir.join("#{code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts "Company #{code} info =========== #{index}"

      if doc.present? && doc.css(".fund_info").blank?
        next
      end


      fund_info = doc.css(".fund_info");


      eastmoney_info = catalog.catalog_eastmoney_info

      if eastmoney_info.blank?
        eastmoney_info = catalog.create_catalog_eastmoney_info(catalog_code: catalog.code)
      end

      puts "Company #{code} header_info_ele 1=========== #{index}"
      header_info_ele = fund_info.css(".header")

      if header_info_ele.present?
        eastmoney_info.header_info['title'] = header_info_ele.css(".title a").text.try(:strip)
        eastmoney_info.header_info['title_en'] = header_info_ele.css(".title_en a").text.try(:strip)
      end


      puts "Company #{code} body_info_ele 2=========== #{index}"
      body_info_ele = fund_info.css(".col_up table").select{|table_ele| (table_ele.text =~ /办公地址/) && (table_ele.text =~ /网站地址/) && (table_ele.text =~ /总经理/) }[0]

      if body_info_ele.present?
        body_info_ele.css("td").each_slice(2) do |key_value_ele|
          # key = td_ele.children[0].text
          # value = td_ele.css("span").text

          key_ele = key_value_ele.first
          value_ele = key_value_ele.last

          key = key_ele.text.try(:strip)
          value = value_ele.text.try(:strip)

          # puts key
          # puts value
          eastmoney_info.body_info[key] = value
        end
      end

      puts "Company #{code} table_info_ele 3=========== #{index}"
      table_info_ele = fund_info.css(".col_down table").select{|table_ele| (table_ele.text =~ /成立日期/) && (table_ele.text =~ /经理人数/) && (table_ele.text =~ /基金总数/) }[0]

      if table_info_ele.present?
        table_info_ele.css("td").each_slice(2) do |key_value_ele|
          key_ele = key_value_ele.first
          value_ele = key_value_ele.last

          key = key_ele.text.try(:strip)
          value = value_ele.text.try(:strip)

          # puts key
          # puts value
          eastmoney_info.table_info[key] = value
        end
      end

      # if eastmoney_info.changed?
        eastmoney_info.save
      # end

      puts doc.css(".cortop").text
    end
  end
end
