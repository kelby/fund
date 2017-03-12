require 'headless'
require 'watir'
require 'nokogiri'
require 'selenium-webdriver'

namespace :morningstar: do
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
    browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"

    browser.span(id: "ctl00_cphMain_lblRatingDate").text


    rating_date = browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    if rating_date.present?
      rating_date = rating_date.text.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end


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
    puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "old_rating_date"
    puts old_rating_date


    browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"
    new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts "new_rating_date"
    puts new_rating_date

    if old_rating_date == new_rating_date
      browser.refresh
      puts "After browser.refresh"
      puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    end


    browser.a(id: "ctl00_cphMain_lbPerformance").click

    # old_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text
    # puts "old_rating_date"
    # puts old_rating_date


    puts browser.span(id: "ctl00_cphMain_lblRatingDate").text
    puts browser.table(id: "ctl00_cphMain_gridResult").text

    # browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"

    # new_rating_date = browser.span(id: "ctl00_cphMain_lblRatingDate").text


    # if old_rating_date == new_rating_date
    #   browser.refresh
    # end



    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("50");
    browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    if new_rating_date.present?
      rating_date = new_rating_date.to_time.strftime("%F")

      today_date = rating_date
    else
      return
    end


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
    browser.cookies.add 'authWeb', "87DB623D94BCA76A59D5466C01049674185AC860565196DFC0D0DC3579EF98F1A22A1CA5D6638647B0763C78729230219CF858D988BB4D307C48B58DC44D5EFDC2DBCC10EBD298FEF010497CB9D146F8EFC6E153DAF5F219CDF84ECB1FED89E0AA147233CD10CFABAA9BACCB8E76FCACAFD7A7F1"

    browser.span(id: "ctl00_cphMain_lblRatingDate").text


    rating_date = browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("10000");

    if rating_date.present?
      rating_date = rating_date.text.to_time.strftime("%F")

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
      project_category = x.css("td")[4]
      _star_rating_three_year = x.css("td")[5]
      _star_rating_five_year = x.css("td")[6]
      record_at = x.css("td")[7]
      dwjz = x.css("td")[8]
      iopv = x.css("td")[9]
      yield_rate = x.css("td")[10]

      morningstar_code = project_name.css("a").attr("href").value.split("/").last
      star_rating_three_year = _star_rating_three_year.children.css("img").attr("src").value.scan(/\d?stars/)[0].scan(/^\d?/)[0]
      star_rating_five_year = _star_rating_five_year.children.css("img").attr("src").value.scan(/\d?stars/)[0].scan(/^\d?/)[0]

      QuickrankSnapshot.create(rating_date: rating_date.text.to_time,
        project_code: project_code.text,
        morningstar_code: morningstar_code,
        project_name: project_name.text,
        project_category: project_category.text,
        star_rating_three_year: star_rating_three_year,
        star_rating_five_year: star_rating_five_year,
        record_at: record_at.text.to_time,
        dwjz: dwjz.text.to_f,
        iopv: iopv.text.to_f,
        yield_rate:  yield_rate.text.to_f)
    end

    browser.close
    headless.destroy
  end
end
