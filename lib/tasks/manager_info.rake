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
    file_name_with_path = manager_dir.join("#{developer.code}.html")


    begin
      File.open(file_name_with_path, 'w:GB2312') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{catalog.code}"
    end

    # 基金经理：丁杰科
    jlinfo = browser.div(class: 'jlinfo')
    developer.description = jlinfo.p.text


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
      project_id = Project.find_by(code: _code).id
      beginning_work_date = f.text.split(" ").first.try(:to_time)
      end_of_work_date = f.text.split(" ").last.try(:to_time)

      DeveloperProject.find_or_create_by(developer_id: developer.id, project_id: project_id) do |dp|
        dp.beginning_work_date = f.text.split("~")
      end
    end


    # 丁杰科现任基金业绩与排名详情
    old_projects_ele = browser.tables(class: 'ftrs')[1]
  end


  browser.close
  headless.destroy
end
