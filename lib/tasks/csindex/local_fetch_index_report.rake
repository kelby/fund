namespace :csindex do
  desc "Task description"
  task :local_fetch_index_report => [:environment] do

    index_report_dir ||= Rails.public_path.join("stock/csindex/show")

    Dir.entries(index_report_dir).each_with_index do |file_name, index|
      file_path = index_report_dir.join(file_name)


      _code = file_name.split(".").first
      index_report = IndexReport.find_by(code: _code)

      if index_report.blank?
        next
      end


      doc = Nokogiri::HTML(open(file_path).read);

      table_title_eles = doc.css(".table > .t_title")

      if table_title_eles.blank?
        next
      end

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
    end

  end
end
