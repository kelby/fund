desc "fetch manager info."
task :fetch_manager_info => [:environment] do
  headless = Headless.new
  headless.start
  browser = Watir::Browser.new

  Developer.find_each do |developer|
    url = developer.eastmoney_url

    browser.goto url
    browser.refresh



    manager_dir = Rails.public_path.join("manager")
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
