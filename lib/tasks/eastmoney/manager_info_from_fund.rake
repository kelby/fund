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
  task :set_developer_project_from_fund => [:environment, :set_present_dp_eastmoney_code] do
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

        pairs = {code => []}

        table_ele.css("tbody tr").each do |tr_ele|
          aa = tr_ele.css("td")[0]
          bb = tr_ele.css("td")[1]
          cc = tr_ele.css("td")[2]

          dd = tr_ele.css("td")[3]
          ee = tr_ele.css("td")[4]

          beginning_work_date = aa.text.to_time
          end_of_work_date = bb.text.to_time

          fund_codes = cc.css("a").map{|x| x.attr('href') }.map { |e| e.split(/\/|\./)[-2] }
          # fund_codes_hash = cc.css("a").map{|x| x.attr('href') }.map { |e| (e.split(/\/|\./)[-2]) => e }
          magic_fund_hash = cc.css("a").map{|x| {x.attr('href').split(/\/|\./)[-2] =>[(x.attr('href')), x.text] }}

          term_of_office = dd.text
          as_return = ee.text.to_f

          pairs[code] += fund_codes

          fund_codes.each do |developer_eastmoney_code|
            dps = DeveloperProject.where(beginning_work_date: beginning_work_date,
              project_id: project.id,
              developer_eastmoney_code: developer_eastmoney_code)

            if dps.present? && dps.one?
              dp = dps.first

              dp.end_of_work_date = end_of_work_date
              dp.term_of_office = term_of_office
              dp.as_return = as_return

              if dp.changed?
                dp.save
              end

              next
            end

            if dps.blank?
              magic_fund_hash.each do |_x|
                _x.each_pair do |_eastmoney_code, eastmoney_url_name|
                  Developer.find_or_create_by(eastmoney_code: _eastmoney_code, name: eastmoney_url_name.last) do |_developer|
                    _developer.eastmoney_url = eastmoney_url_name.first
                  end
                end
              end
            end

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

      if project.developer_projects.count != pairs[code].size
        puts "project.developer_projects.count"
        puts project.developer_projects.count
        puts pairs[code].size
        puts pairs[code]
      end
      # begin
      #   File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      # rescue Exception => e
      #   puts "=============Error #{project.id} #{code}"
      # end
    end
  end

  desc "set present developer_project's eastmoney_code"
  task :set_present_dp_eastmoney_code => [:environment] do

    DeveloperProject.count
    DeveloperProject.where(developer_eastmoney_code: [nil, '']).count

    DeveloperProject.where(developer_eastmoney_code: [nil, '']).find_each do |dp|
      dp.developer_eastmoney_code = dp.developer.eastmoney_code;

      if dp.changed?
        dp.save
      else
        next
      end
    end

    DeveloperProject.count
    DeveloperProject.where(developer_eastmoney_code: [nil, '']).count

  end
end
