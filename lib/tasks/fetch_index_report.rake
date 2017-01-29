desc "Fetch csindex.com.cn sseportal/csiportal/zs/indexreport. list"
task :fetch_csindex_index_report => [:environment] do
  sb = SpiderBase.new


  catalogs = %W{
  中证系列指数
  上证系列指数
  中华交易服务系列指数
  深证系列指数
  三板系列指数}

  catalog_indexs = [1, 2, 4, 3, 5]

  base_url = "http://www.csindex.com.cn"

  catalogs.each_with_index do |catalog, index|
    sb ||= SpiderBase.new
    index ||= 0

    type = catalog_indexs[index]
    url = "#{base_url}/sseportal/csiportal/zs/indexreport.do?type=#{type}"


    fetch_content = sb.page_for_url(url);
    puts "Fetch index_report #{catalog} data from #{url} =========== #{index}"

    doc = fetch_content.doc;


    table_title_eles = doc.css(".table > .t_title")

    table_title_eles.each do |table_title_ele|
      category = table_title_ele.css("a").text.strip

      category_intro = table_title_ele.next_element.text

      content_table_ele = table_title_ele.next_element.next_element

      if content_table_ele.name == "table"
        puts "fetch content table"

        content_table_ele.css("tr").each do |tr_ele|
          td_eles = tr_ele.css("td")


          tds_text = td_eles.map{|x| x.text.strip }.join(",")
          if tds_text =~ /指数名称|基准日期|基准点数|成份股数量/
            next
          end



          # td_eles.each do |td_ele|
            # ...
          # end
          if td_eles.blank?
            next
          end

          aa, bb, cc, dd = td_eles

          website_value = aa.css("a").attr('href').value

          website = "#{base_url}#{website_value}"

          IndexReport.create(catalog: catalog,
            category: category,
            category_intro: category_intro,
            name: aa.text.strip,
            set_up_at: bb.text.strip,
            website: website)
        end


        if content_table_ele.next_element.blank?
          next
        end

        more_content_table_ele = content_table_ele.next_element.css("table")

        if more_content_table_ele.present?
          puts "fetch more content table"



          # begin 重复代码
          more_content_table_ele.css("tr").each do |tr_ele|
            td_eles = tr_ele.css("td")


            tds_text = td_eles.map{|x| x.text.strip }.join(",")
            if tds_text =~ /指数名称|基准日期|基准点数|成份股数量/
              next
            end



            # td_eles.each do |td_ele|
              # ...
            # end
            aa, bb, cc, dd = td_eles

            website_value = aa.css("a").attr('href').value

            website = "#{base_url}#{website_value}"

            IndexReport.create(catalog: catalog,
              category: category,
              category_intro: category_intro,
              name: aa.text.strip,
              set_up_at: bb.text.strip,
              website: website)
          end
          # end 重复代码



        else
          next
        end
      else
        next
      end
    end
  end
end

desc "Fetch csindex.com.cn index_report. show"
task :fetch_index_report_detail => [:environment] do
  sb = SpiderBase.new
  # base_url = "http://www.csindex.com.cn"
  index ||= 0

  IndexReport.find_each.with_index do |index_report, index|
    # IndexReport.limit(20).each_with_index do |index_report, index|

    url = index_report.website

    if url.blank?
      next
    end

    fetch_content = sb.page_for_url(url);

    puts "Fetch index_report #{index_report.name} data from #{url} =========== #{index}"

    doc = fetch_content.doc;

    table_title_eles = doc.css(".table > .t_title")

    table_title_eles.each do |table_title_ele|
      title_text = table_title_ele.text.strip

      case title_text
        # begin 简介
      when "指数介绍"

        if table_title_ele.next_element.blank?
          next
        end

        content_table_ele = table_title_ele.next_element.css("table")

        if content_table_ele.present?
          puts "fetch content table"

          intro = content_table_ele.css("tr").text.strip
          index_report.intro = intro
          # each do |tr_ele|
            # td_eles = tr_ele.css("td")
          # end
        end
      when "行情走势"
        # begin code
        code_table_ele = doc.css(".container-r table.list-table")

        code_ele = code_table_ele.css("td")[0]

        if code_ele.text.strip =~ /指数代码/
          code = code_ele.next_element.text.try(:strip)

          if code =~ /\d$/
            index_report.code = code
          end

          if index_report.changed?
            index_report.save
          end


          next
        end


        code_table_ele.css("td").each do |td_ele|
          if td_ele.text.strip =~ /指数代码/
            


            code = td_ele.next_element.text.try(:strip)

            if code =~ /\d$/
              index_report.code = code
            end

            if index_report.changed?
              index_report.save
            end


            break



          end
        end
        # end code
      else
        # ...
        next
      end
    end
    # end 简介

  end
end

