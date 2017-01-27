desc "fetch hexun project show datas"
task :fetch_hexun_project_show => [:environment] do
  headless = Headless.new
  headless.start
  browser = Watir::Browser.new

  Project.where(set_up_at: [nil, '']).find_each.with_index do |project|
  # Project.limit(20).each_with_index do |project, index|
    code = project.code

    url = "http://jingzhi.funds.hexun.com/#{code}.shtml"
    puts "Fetch project #{code} data from #{url} =========== #{index}"

    browser.goto url
    browser.refresh


    fund_dir = Rails.public_path.join("fund/hexun")
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
      next
    end

    puts "project #{code} set_up_at #{set_up_at}"
    project.set_up_at = set_up_at

    if project.changed?
      project.save
    end
    # ...
  end

  browser.close
  headless.destroy
end