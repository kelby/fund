namespace :eastmoney do
  # 方法一
  desc "fetch manager info. show"
  task :fetch_manager_info => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    # 这种方法用的是浏览器，比较笨重
    Developer.find_each do |developer|
      url = developer.eastmoney_url

      browser.goto url
      browser.refresh



      manager_dir = Rails.public_path.join("manager/eastmoney")
      FileUtils::mkdir_p(manager_dir)

      # yourfile = Rails.public_path.join("company/#{catalog.code}.html")
      file_name_with_path = manager_dir.join("#{developer.id}.html")


      begin
        File.open(file_name_with_path, 'w:GB2312') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "=============Error #{developer.id}"
      end

      # 基金经理：丁杰科
      jlinfo = browser.div(class: 'jlinfo')
      developer.description = jlinfo.p.text

      developer.description.strip.gsub(/^基金经理简介：/, "") if developer.description.present?

      if developer.description_changed?
        developer.save
      end


      # 丁杰科管理过的基金一览
      now_projects_ele = browser.tables(class: 'ftrs')[0]
      now_projects_ele.tbody.trs.each do |tr_ele|
        # 基金代码  基金名称  相关链接  基金类型  规模（亿元）  任职时间  任职天数  任职回报
        a = tr_ele.tds[0]
        b = tr_ele.tds[1]
        c = tr_ele.tds[2]
        d = tr_ele.tds[3]
        e = tr_ele.tds[4]
        f = tr_ele.tds[5]
        g = tr_ele.tds[6]
        i = tr_ele.tds[7]

        _code = a.text
        _project = Project.find_by(code: _code)

        _catalog_id = developer.catalogs.last.id if developer.catalogs.present?

        if _project.blank?
          puts "code #{_code} without proejct."
          _project = Project.create(code: _code, name: b.text, mold: d.text, catalog_id: _catalog_id) if _catalog_id.present?
          next
        end

        project_id = _project.id
        beginning_work_date = f.text.split(" ").first.try(:to_time)
        end_of_work_date = f.text.split(" ").last.try(:to_time)

        puts "developer_id #{developer.id}, project_id #{project_id}, beginning_work_date #{beginning_work_date}, end_of_work_date #{end_of_work_date}"

        DeveloperProject.find_or_create_by(developer_id: developer.id, project_id: project_id) do |dp|
          dp.beginning_work_date = beginning_work_date
          dp.beginning_work_date = end_of_work_date
        end
      end


      # 丁杰科现任基金业绩与排名详情
      old_projects_ele = browser.tables(class: 'ftrs')[1]

      sleep(rand(1..10.0))
    end


    browser.close
    headless.destroy
  end

  # 方法二
  desc "Fetch manager/developer data for association catalog. show"
  task :fetch_manager_info_for_current_catalog => [:environment] do
    sb = SpiderBase.new

    # developers ||= Developer.where(name: "石大怿")

    # take_office_date
    number = Developer.where.not(take_office_date: [nil, '']).last.id

    # 这种方法比较轻巧
    # Developer.limit(10).each_with_index do |developer, index|
    Developer.where("id >= ?", number).find_each.each_with_index do |developer, index|
      url = developer.eastmoney_url

      # next if url.blank?

      sb ||= SpiderBase.new

      fetch_content = sb.page_for_url(url);
      puts "Fetch developer #{developer.id} data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      jd = doc.css(".right.jd")

      want_span_ele = jd.css("span")

      want_span_ele.each do |span_ele|
        span_text = span_ele.text

        if span_text =~ /任职起始日期/
          take_office_date = span_ele.next_sibling.text.try(:strip)

          developer.take_office_date = take_office_date
          next
        end

        if span_text =~ /现任基金公司/
          company_url = span_ele.next_element.attributes['href'].value

          codes = developer.catalogs.pluck(:code)

          if codes.any?{|code| company_url.include?(code) }
            # ...
            next
          else
            # ...
            company_code = company_url.split(/\.|\//)[-2]


            unless company_code =~ /\d$/
              next
            end

            catalog = Catalog.find_by(code: company_code)
            CatalogDeveloper.find_or_create_by(catalog_id: catalog.id, developer_id: developer.id)
          end

          next
        end
      end

      # 基金经理：丁杰科
      jlinfo = doc.css('.jlinfo')
      developer.description = jlinfo.css("p").text.try(:strip)

      developer.remote_avatar_url = doc.css(".left > #photo").attr('src').value


      if developer.changed?
        developer.save
      end



      # 丁杰科管理过的基金一览
      now_projects_ele = doc.css("table.ftrs")[0]

      now_projects_ele.css("tbody tr").each do |tr_ele|
        # 基金代码  基金名称  相关链接  基金类型  规模（亿元）  任职时间  任职天数  任职回报
        a = tr_ele.css("td")[0]
        b = tr_ele.css("td")[1]
        c = tr_ele.css("td")[2]
        d = tr_ele.css("td")[3]
        e = tr_ele.css("td")[4]
        f = tr_ele.css("td")[5]
        g = tr_ele.css("td")[6]
        i = tr_ele.css("td")[7]

        _code = a.text
        _project = Project.find_by(code: _code)


        _catalog_id = developer.catalogs.last.id if developer.catalogs.present?


        if _project.blank?
          puts "code #{_code} without proejct."
          _project = Project.create(code: _code, name: b.text, mold: d.text, catalog_id: _catalog_id) if _catalog_id.present?
          next
        end

        project_id = _project.id
        beginning_work_date = f.text.split(" ").first.try(:to_time)
        end_of_work_date = f.text.split(" ").last.try(:to_time)

        puts "developer_id #{developer.id}, project_id #{project_id}, beginning_work_date #{beginning_work_date}, end_of_work_date #{end_of_work_date}"

        DeveloperProject.find_or_create_by(developer_id: developer.id, project_id: project_id) do |dp|
          dp.beginning_work_date = beginning_work_date
          dp.beginning_work_date = end_of_work_date
        end
      end


    end
  end

  desc "fetch and save eastmoney manager info to dir"
  task :save_eastmoney_manager_info => [:environment] do
    sb ||= SpiderBase.new
    number ||= 0

    Developer.where("id >= ?", number).find_each.each_with_index do |developer, index|
      url = developer.eastmoney_url

      if url.blank?
        next
      end

      sb ||= SpiderBase.new

      fetch_content = sb.page_for_url(url);
      puts "Fetch developer #{developer.id} data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      manager_dir = Rails.public_path.join("manager/eastmoney/info")
      FileUtils::mkdir_p(manager_dir)

      file_name_with_path = manager_dir.join("#{developer.id}.html")


      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{developer.id}, Exception #{e}"
        break
      end

    end
  end

  desc "set manager description"
  task :set_manager_description => [:environment] do
    Developer.where(description: [nil, ""]).find_each.with_index do |developer, index|
      manager_dir = Rails.public_path.join("manager/eastmoney/info")
      # FileUtils::mkdir_p(manager_dir)

      # yourfile = Rails.public_path.join("company/#{catalog.code}.html")
      file_name_with_path = manager_dir.join("#{developer.id}.html")


      # begin
      #   File.open(file_name_with_path, 'w:GB2312') { |file| file.write(browser.html) }
      # rescue Exception => e
      #   puts "=============Error #{developer.id}"
      # end

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      # 基金经理：丁杰科
      jlinfo = doc.css('.jlinfo')
      developer.description = jlinfo.css("p").text

      developer.description.strip.gsub(/^基金经理简介：/, "") if developer.description.present?

      if developer.description_changed?
        developer.save
      end


      # 丁杰科管理过的基金一览
      now_projects_ele = doc.css("table.ftrs")[0]

      now_projects_ele.css("tbody tr").each do |tr_ele|
        # 基金代码  基金名称  相关链接  基金类型  规模（亿元）  任职时间  任职天数  任职回报
        a = tr_ele.css("td")[0]
        b = tr_ele.css("td")[1]
        c = tr_ele.css("td")[2]
        d = tr_ele.css("td")[3]
        e = tr_ele.css("td")[4]
        f = tr_ele.css("td")[5]
        g = tr_ele.css("td")[6]
        i = tr_ele.css("td")[7]

        _code = a.text
        _project = Project.find_by(code: _code)

        _catalog_id = developer.catalogs.last.id if developer.catalogs.present?

        if _project.blank?
          puts "code #{_code} without proejct."
          _project = Project.create(code: _code, name: b.text, mold: d.text, catalog_id: _catalog_id) if _catalog_id.present?
          next
        end

        project_id = _project.id
        beginning_work_date = f.text.split(" ").first.try(:to_time)
        end_of_work_date = f.text.split(" ").last.try(:to_time)

        puts "developer_id #{developer.id}, project_id #{project_id}, beginning_work_date #{beginning_work_date}, end_of_work_date #{end_of_work_date}"

        DeveloperProject.find_or_create_by(developer_id: developer.id, project_id: project_id) do |dp|
          dp.beginning_work_date = beginning_work_date
          dp.beginning_work_date = end_of_work_date
        end
      end
    end
  end

  desc "set manager avatar"
  task :set_manager_avatar => [:environment] do
    Developer.where(avatar: [nil, ""]).find_each.with_index do |developer, index|
      manager_dir = Rails.public_path.join("manager/eastmoney/info")
      # FileUtils::mkdir_p(manager_dir)

      # yourfile = Rails.public_path.join("company/#{catalog.code}.html")
      file_name_with_path = manager_dir.join("#{developer.id}.html")


      # begin
      #   File.open(file_name_with_path, 'w:GB2312') { |file| file.write(browser.html) }
      # rescue Exception => e
      #   puts "=============Error #{developer.id}"
      # end

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      # 基金经理：丁杰科
      developer.remote_avatar_url = doc.css(".left > #photo").attr('src').value

      if developer.changed?
        developer.save
      end
    end
  end

  desc "set developer_project from manager show"
  task :set_developer_project => [:environment] do
    Developer.where.not(eastmoney_url: [nil, ""]).find_each.with_index do |developer, index|
      manager_dir = Rails.public_path.join("manager/eastmoney/info")

      file_name_with_path = manager_dir.join("#{developer.id}.html")


      doc = Nokogiri::HTML(open(file_name_with_path).read);


      manager_funds_ele = doc.css("table.ftrs")[0];
      trs_ele = manager_funds_ele.css("tbody tr")

      trs_ele.each do |tr_ele|
        aa, bb, cc, dd, ee, ff, gg, hh = tr_ele.css("td")

        code = aa.css("a").text
        name = bb.css("a").text
        date_range = ff.text

        DeveloperProject.find_or_create_by(developer_id: developer.id, project_code: code) do |developer_project|
          developer_project.beginning_work_date = date_range.split(" ").first.try(:to_time)
          developer_project.end_of_work_date = date_range.split(" ").last.try(:to_time)
        end
      end
    end
  end
end
