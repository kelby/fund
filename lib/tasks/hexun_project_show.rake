desc "fetch hexun project show datas"
task :fetch_hexun_project_show => [:environment] do
  headless = Headless.new
  headless.start
  browser = Watir::Browser.new

  Project.find_each do |project|
  # Project.limit(20) do |project|
    code = project.code

    url = "http://jingzhi.funds.hexun.com/#{code}.shtml"
    puts "Fetch project #{code} data from #{url} ==========="

    browser.goto url
    browser.refresh

    set_up_at = browser.span(id: "signdate").text

    project.set_up_at = set_up_at

    if project.changed?
      project.save
    end
    # ...
  end

  browser.close
  headless.destroy
end