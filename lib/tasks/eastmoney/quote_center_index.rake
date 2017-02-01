desc "Task description"
task :task_name => [:environment] do

  headless ||= Headless.new
  headless.start
  browser ||= Watir::Browser.new

  name_url = {
    Pinyin.t("沪深指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/index.html#zyzs_0_1",
    Pinyin.t("上海指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#15_0_1",
    Pinyin.t("深圳指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#25_0_1",
    Pinyin.t("指数成分", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#35_0_1"}

  name_url.each_pair do |name, url|
    # url = "http://quote.eastmoney.com/center/index.html#zyzs_0_1"
    browser.goto url
    browser.refresh


    fund_dir = Rails.public_path.join("quote/eastmoney/zyzs")
    FileUtils::mkdir_p(fund_dir)

    file_name_with_path = fund_dir.join("#{name}.html")


    begin
      File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "============= Exception #{e}"
    end
  end

  # zyzs = browser.div("#zyzs")

  browser.close
  headless.destroy
end