namespace :hexun do
  # Watir
  desc "fetch hexun project show datas"
  task :fetch_hexun_project_show => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    number = 0
    number = Project.where.not(set_up_at: [nil, '']).last.id

    # Project.limit(20).each_with_index do |project, index|
    Project.where(set_up_at: [nil, '']).where("id > ?", number).find_each.with_index do |project, index|
      if project.nightspot?
        next
      end

      if project.offline?
        next
      end

      code = project.code

      url = "http://jingzhi.funds.hexun.com/#{code}.shtml"
      puts "Fetch project #{code} data from #{url} =========== #{index}"

      browser.goto url
      browser.refresh


      fund_dir = Rails.public_path.join("fund/hexun/show")
      FileUtils::mkdir_p(fund_dir)

      file_name_with_path = fund_dir.join("#{project.code}.html")


      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "=============Error #{project.code}, Exception #{e}"
      end

      unless browser.span(id: "signdate").exists?
        next
      end

      set_up_at = browser.span(id: "signdate").text

      if set_up_at.blank?
        # 为空
        project.nightspot!
        next
      end

      if set_up_at == "未成立"
        project.offline!
        next
      end

      puts "project #{code} set_up_at #{set_up_at}"
      project.set_up_at = set_up_at

      if project.changed?
        project.save
      end
      # ...

      # sleep(rand(1..10.0))
    end

    browser.close
    headless.destroy
  end

  # Watir
  desc "save fetch hexun project show datas to dir"
  task :save_fetch_hexun_project_show_to_dir => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    fund_dir = Rails.public_path.join("fund/hexun/show")
    FileUtils::mkdir_p(fund_dir)

    # number = 0
    # number = Project.where.not(set_up_at: [nil, '']).last.id

    # Project.where(set_up_at: [nil, '']).where("id > ?", number).find_each.with_index do |project, index|
    Project.find_each.with_index do |project, index|
      code = project.code

      url = "http://jingzhi.funds.hexun.com/#{code}.shtml"
      puts "Fetch project #{code} data from #{url} =========== #{index}"

      browser.goto url
      browser.refresh


      file_name_with_path = fund_dir.join("#{project.code}.html")


      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "=============Error #{project.code}, Exception #{e}"
      end

      unless browser.span(id: "signdate").exists?
        next
      end

      set_up_at = browser.span(id: "signdate").text

      if set_up_at.blank?
        # 为空
        project.nightspot!
        next
      end

      if set_up_at == "未成立"
        project.offline!
        next
      end
    end

    browser.close
    headless.destroy
  end

  # SpiderBase
  desc "Task description"
  task :fetch_hexun_fund_show => [:environment] do
    sb = SpiderBase.new
    blank_fund_pages = []
    fund_dir ||= Rails.public_path.join("fund/hexun/show")
    FileUtils::mkdir_p(fund_dir)

    Project.find_each.with_index do |project, index|
      code = project.code
      url = "http://jingzhi.funds.hexun.com/#{code}.shtml"


      fetch_content = sb.page_for_url(url);
      puts "Fetch hexun fund #{code} show data from #{url} =========== #{index}"

      doc = fetch_content.doc;

      if doc.css(".listnum").present?
        file_name_with_path = fund_dir.join("#{code}.html")

        begin
          File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(doc.to_html) }
        rescue Exception => e
          puts "=============Error #{code}, Exception #{e}"
          break
        end
      else
        blank_fund_pages << "#{code}--#{project.name}"
      end
    end

    puts "以下 #{blank_fund_pages.size} 基金没有抓取到展示页面\n"
    puts blank_fund_pages.join(', ')
  end
end
