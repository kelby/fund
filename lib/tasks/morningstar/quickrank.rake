require 'headless'
require 'watir'
require 'nokogiri'
require 'selenium-webdriver'

namespace :morningstar do
  desc "Task description"
  task :quickrank => [:environment] do


    headless ||= Headless.new
    headless.start

    browser ||= Watir::Browser.new

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/snapshot")
    FileUtils::mkdir_p(morningstar_quickrank_dir)



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url
    # browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"


    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date


    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"


    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh

      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end

    # rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

    if new_rating_date.present?
      new_rating_date = new_rating_date.to_time.strftime("%F")

      today_date = new_rating_date
    else
      return
    end

    browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000")
    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").value("100").change()



    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")


    puts "gridItem.size"
    puts browser.trs(class: "gridItem").size
    # browser.trs(class: "gridAlternateItem").size

    begin
      File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "============= Exception #{e}"
    end

    doc = Nokogiri::HTML(browser.html)



    if doc.present?
      puts "gridItem.size"
      puts doc.css("tr.gridItem").size

      puts "gridAlternateItem.size"
      puts doc.css("tr.gridAlternateItem").size
    end

    browser.close
    headless.destroy
  end

  desc "Task description"
  task :set_quickrank_snapshot => [:environment] do
    headless ||= Headless.new
    headless.start

    browser ||= Watir::Browser.new

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/snapshot")



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url
    # browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"

    # rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date


    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"


    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end

    # rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

    if new_rating_date.present?
      new_rating_date = new_rating_date.to_time.strftime("%F")

      today_date = new_rating_date
    else
      return
    end

    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    # if rating_date.present?
    #   rating_date = rating_date.to_time.strftime("%F")

    #   today_date = rating_date
    # else
    #   return
    # end


    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")

    # ============================= 上述不再直接参与数据抓取，只为了获取本地文件名 ================

    doc = Nokogiri::HTML(open(file_name_with_path).read);

    rating_date = doc.css("#ctl00_cphMain_lblRatingDate")

    puts "gridItem.size"
    puts doc.css("tr.gridItem").size

    puts "gridAlternateItem.size"
    puts doc.css("tr.gridAlternateItem").size

    doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      id = x.css("td")[0]
      checkbox = x.css("td")[1]
      project_code = x.css("td")[2]
      project_name = x.css("td")[3]
      project_category = x.css("td")[4]
      _star_rating_three_year = x.css("td")[5]
      _star_rating_five_year = x.css("td")[6]
      record_at = x.css("td")[7]
      _dwjz = x.css("td")[8]
      _iopv = x.css("td")[9]
      _yield_rate = x.css("td")[10]

      morningstar_code = project_name.css("a").attr("href").value.split("/").last
      star_rating_three_year = _star_rating_three_year.children.css("img").attr("src").value.scan(/\d?stars/)[0].scan(/^\d?/)[0]
      star_rating_five_year = _star_rating_five_year.children.css("img").attr("src").value.scan(/\d?stars/)[0].scan(/^\d?/)[0]

      dwjz = (_dwjz.text =~ /\d/)? _dwjz.text.gsub(/[^(-|\.|\d)]/, "") : nil
      iopv = (_iopv.text =~ /\d/)? _iopv.text.gsub(/[^(-|\.|\d)]/, "") : nil
      yield_rate = (_yield_rate.text =~ /\d/)? _yield_rate.text.gsub(/[^(-|\.|\d)]/, "") : nil

      QuickrankSnapshot.create(rating_date: rating_date.text.to_time,
        project_code: project_code.text,
        morningstar_code: morningstar_code,
        project_name: project_name.text,
        project_category: project_category.text,
        star_rating_three_year: star_rating_three_year,
        star_rating_five_year: star_rating_five_year,
        record_at: record_at.text.to_time,
        dwjz: dwjz,
        iopv: iopv,
        yield_rate: yield_rate)
    end

    browser.close
    headless.destroy
  end

  # ==================================================

  desc "Task description"
  task :performance => [:environment] do

    headless ||= Headless.new
    headless.start

    browser ||= Watir::Browser.new

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/performance")
    FileUtils::mkdir_p(morningstar_quickrank_dir)



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url
    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date


    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"

    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end


    browser.a(id: "ctl00_cphMain_lbPerformance").click

    # old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    # puts "old_rating_date"
    # puts old_rating_date



    if new_rating_date.present?
      rating_date = new_rating_date.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end


    puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: 'header').text

    # browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"

    # new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # if old_rating_date == new_rating_date
    #   browser.refresh
    # end



    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("50");
    browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");



    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")


    # puts "gridItem.size"
    # puts browser.trs(class: "gridItem").size
    # browser.trs(class: "gridAlternateItem").size

    begin
      File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "============= Exception #{e}"
    end

    doc = Nokogiri::HTML(browser.html)



    if doc.present?
      puts "gridItem.size"
      puts doc.css("tr.gridItem").size

      puts "gridAlternateItem.size"
      puts doc.css("tr.gridAlternateItem").size
    end

    browser.close
    headless.destroy
  end

  desc "Task description"
  task :set_quickrank_performance => [:environment] do
    headless ||= Headless.new
    headless.start

    browser ||= Watir::Browser.new

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/performance")



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url

    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date

    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"

    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end

    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # rating_date = browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    # if rating_date.present?
    #   rating_date = rating_date.text.to_time.strftime("%F")

    #   today_date = rating_date
    # else
    #   return
    # end

    if new_rating_date.present?
      rating_date = new_rating_date.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end



    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")
    # ============================= 上述不再直接参与数据抓取，只为了获取本地文件名 ================



    doc = Nokogiri::HTML(open(file_name_with_path).read);

    rating_date = doc.css("#ctl00_cphMain_lblRatingDate")

    puts "gridItem.size"
    puts doc.css("tr.gridItem").size

    puts "gridAlternateItem.size"
    puts doc.css("tr.gridAlternateItem").size

    doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      id = x.css("td")[0]
      checkbox = x.css("td")[1]
      project_code = x.css("td")[2]
      project_name = x.css("td")[3]

      last_day_total_return = x.css("td")[4]
      last_week_total_return = x.css("td")[5]
      last_month_total_return = x.css("td")[6]
      last_three_month_total_return = x.css("td")[7]
      last_six_month_total_return = x.css("td")[8]
      last_year_total_return = x.css("td")[9]
      last_two_year_total_return = x.css("td")[10]
      last_three_year_total_return = x.css("td")[11]
      last_five_year_total_return = x.css("td")[12]
      last_ten_year_total_return = x.css("td")[13]
      since_the_inception_total_return = x.css("td")[14]

      three_year_volatility = x.css("td")[15]
      three_year_risk_factor = x.css("td")[16]

      morningstar_code = project_name.css("a").attr("href").value.split("/").last

      QuickrankPerformance.create(rating_date: rating_date.text.to_time,
        project_code: project_code.text,
        morningstar_code: morningstar_code,
        project_name: project_name.text,

        last_day_total_return:  ((last_day_total_return.text =~ /\d/)? last_day_total_return.text.to_f : nil),
        last_week_total_return:  ((last_week_total_return.text =~ /\d/)? last_week_total_return.text.to_f : nil),
        last_month_total_return:  ((last_month_total_return.text =~ /\d/)? last_month_total_return.text.to_f : nil),
        last_three_month_total_return:  ((last_three_month_total_return.text =~ /\d/)? last_three_month_total_return.text.to_f : nil),
        last_six_month_total_return:  ((last_six_month_total_return.text =~ /\d/)? last_six_month_total_return.text.to_f : nil),
        last_year_total_return:  ((last_year_total_return.text =~ /\d/)? last_year_total_return.text.to_f : nil),
        last_two_year_total_return:  ((last_two_year_total_return.text =~ /\d/)? last_two_year_total_return.text.to_f : nil),
        last_three_year_total_return:  ((last_three_year_total_return.text =~ /\d/)? last_three_year_total_return.text.to_f : nil),
        last_five_year_total_return:  ((last_five_year_total_return.text =~ /\d/)? last_five_year_total_return.text.to_f : nil),
        last_ten_year_total_return:  ((last_ten_year_total_return.text =~ /\d/)? last_ten_year_total_return.text.to_f : nil),
        since_the_inception_total_return:  ((since_the_inception_total_return.text =~ /\d/)? since_the_inception_total_return.text.to_f : nil),

        three_year_volatility:  ((three_year_volatility.text =~ /\d/)? three_year_volatility.text.to_f : nil),
        three_year_risk_factor:  ((three_year_risk_factor.text =~ /\d/)? three_year_risk_factor.text.to_f : nil))
    end

    browser.close
    headless.destroy
  end

  # ==================================================

  desc "Task description"
  task :portfolio => [:environment] do

    headless ||= Headless.new
    headless.start

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 180 # seconds – default is 60
    client.open_timeout = 180 # seconds – default is 60

    # b = Watir::Browser.new :firefox, :http_client => client

    browser ||= Watir::Browser.new :chrome, :http_client => client

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/portfolio")
    FileUtils::mkdir_p(morningstar_quickrank_dir)



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url
    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date


    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"
    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end

    # if old_rating_date == new_rating_date
    #   browser.goto url
    #   puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    #   old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    #   puts "old_rating_date"
    #   puts old_rating_date


    #   browser.cookies.add 'authWeb', "BAAF570AE579D59D6A7FCF11C9C61060F18AE9EDFD70AAF8B45B454E3A268D9BAE8757C2AF1EFA47D2CDD2447B28B2B2FB9C4708E320CC3C1CA82F8942342155A54E6B8F7478EC913F0CDDEB081EB52804752EC023F5582912D841DAEF04EE0956F631C352A712C0F5011EFAAB92139C16D4AAE9"
    #   browser.refresh

    #   new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    #   puts "new_rating_date"
    #   puts new_rating_date
    # end


    browser.a(id: "ctl00_cphMain_lbPortfolio").click

    # old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    # puts "old_rating_date"
    # puts old_rating_date


    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    # puts browser.table(id: "ctl00_cphMain_gridResult").text

    # browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"

    # new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # if old_rating_date == new_rating_date
    #   browser.refresh
    # end

    # -------------------------------------------

    if new_rating_date.present?
      rating_date = new_rating_date.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end

    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("50");
    browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");


    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")


    puts "gridItem.size"
    puts browser.trs(class: "gridItem").size
    # browser.trs(class: "gridAlternateItem").size

    begin
      File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "============= Exception #{e}"
    end

    # doc = Nokogiri::HTML(browser.html)



    # if doc.present?
    #   puts "gridItem.size"
    #   puts doc.css("tr.gridItem").size

    #   puts "gridAlternateItem.size"
    #   puts doc.css("tr.gridAlternateItem").size
    # end

    browser.close
    headless.destroy
  end

  desc "Task description"
  task :set_quickrank_portfolio => [:environment] do
    headless ||= Headless.new
    headless.start

    browser ||= Watir::Browser.new

    today_date = Time.now.strftime("%F")

    public_path = Rails.public_path

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/portfolio")



    url = "https://cn.morningstar.com/quickrank/default.aspx"


    browser.goto url

    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date

    browser.cookies.add 'authWeb', "F55D8234D52DFF49CFB756CDFD89AFF1BBF231045DEA4AF8CC57B6596D92C05B8CB6376371B52D4DB9DC3108BB694716916B5CEC2C6C17D9EF972B1617AF7E0C10C35EE432F0269EA61AC91E2434BEA40A5A32A332B856DD251D307B52FA06BC5AE180DC74AA87F56227A50AF149A96C63F52366"

    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text

      puts "After browser.refresh"
      puts new_rating_date
    end

    # puts browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # rating_date = browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    # if rating_date.present?
    #   rating_date = rating_date.text.to_time.strftime("%F")

    #   today_date = rating_date
    # else
    #   return
    # end

    if new_rating_date.present?
      rating_date = new_rating_date.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end



    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")
    # ============================= 上述不再直接参与数据抓取，只为了获取本地文件名 ================



    doc = Nokogiri::HTML(open(file_name_with_path).read);

    rating_date = doc.css("#ctl00_cphMain_lblRatingDate")

    puts "gridItem.size"
    puts doc.css("tr.gridItem").size

    puts "gridAlternateItem.size"
    puts doc.css("tr.gridAlternateItem").size

    doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      id = x.css("td")[0]
      checkbox = x.css("td")[1]
      project_code = x.css("td")[2]
      project_name = x.css("td")[3]

      _delivery_style = x.css("td")[4]
      stock_ratio = x.css("td")[5]
      bond_ratio = x.css("td")[6]
      top_ten_stock_ratio = x.css("td")[7]
      top_ten_bond_ratio = x.css("td")[8]
      net_asset = x.css("td")[9]

      if _delivery_style.css("img").present?
        delivery_style = _delivery_style.css("img").attr("src").value.scan(/stylesmall_new\d{1,99}/)[0].scan(/\d{1,99}/)[0]
      else
        delivery_style = nil
      end
      morningstar_code = project_name.css("a").attr("href").value.split("/").last

      QuickrankPortfolio.create(rating_date: rating_date.text.to_time,
        project_code: project_code.text,
        morningstar_code: morningstar_code,
        project_name: project_name.text,

        delivery_style: delivery_style,

        stock_ratio: ((stock_ratio.text =~ /\d/)? stock_ratio.text.to_f : nil),
        bond_ratio: ((bond_ratio.text =~ /\d/)? bond_ratio.text.to_f : nil),
        top_ten_stock_ratio: ((top_ten_stock_ratio.text =~ /\d/)? top_ten_stock_ratio.text.to_f : nil),
        top_ten_bond_ratio: ((top_ten_bond_ratio.text =~ /\d/)? top_ten_bond_ratio.text.to_f : nil),

        net_asset: ((net_asset.text =~ /\d/)? net_asset.text.to_f : nil))
    end

    browser.close
    headless.destroy
  end
end
