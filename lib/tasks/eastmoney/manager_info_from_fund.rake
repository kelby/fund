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


  desc "set_developer_project_from_fund."
  task :set_developer_project_from_fund => [:environment] do
    # sb ||= SpiderBase.new
    number = 0
    fund_managers_dir = Rails.public_path.join("fund/eastmoney/managers")


    # Project.limit(3).each_with_index do |project, index|
    Project.where("id > ?", number).find_each.each_with_index do |project, index|
      code = project.code
      file_name_with_path = fund_managers_dir.join("#{code}.html")

      # sb ||= SpiderBase.new

      # url = "http://fund.eastmoney.com/f10/jjjl_#{code}.html"
      # fetch_content = sb.page_for_url(url);
      # puts "Fetch project #{code} data from #{url} =========== #{index}"

      doc = Nokogiri::HTML(open(file_name_with_path).read);


      # fund_managers_dir = Rails.public_path.join("fund/eastmoney/managers")
      # FileUtils::mkdir_p(fund_managers_dir)

      table_eles = doc.css("table.jloff");

      if table_eles.blank?
        next
      else
        table_ele = table_eles[0]

        table_ele.css("tbody tr").each do |tr_ele|
          aa = tr_ele.css("td")[0]
          bb = tr_ele.css("td")[1]
          cc = tr_ele.css("td")[2]

          dd = tr_ele.css("td")[3]
          ee = tr_ele.css("td")[4]

          beginning_work_date = aa.text.to_time
          end_of_work_date = bb.text.to_time

          fund_codes = cc.css("a").map{|x| x.attr('href') }.map { |e| e.split(/\/|\./)[-2] }
          term_of_office = dd.text
          as_return = ee.text.to_f

          fund_codes.each do |developer_eastmoney_code|
            DeveloperProject.create(project_id: project.id,
              # developer_id: developer.id,
              beginning_work_date: beginning_work_date,
              end_of_work_date: end_of_work_date,
              developer_eastmoney_code: developer_eastmoney_code,
              term_of_office: term_of_office,
              as_return: as_return)
          end
        end
      end

      # begin
      #   File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      # rescue Exception => e
      #   puts "=============Error #{project.id} #{code}"
      # end
    end
  end
end
