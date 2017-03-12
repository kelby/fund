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
    # public_path = Pathname.new("/var/www/fund/current/public/")

    morningstar_quickrank_dir = public_path.join("fund/morningstar/quickrank/snapshot")
    FileUtils::mkdir_p(morningstar_quickrank_dir)

    file_name_with_path = morningstar_quickrank_dir.join("#{today_date}.html")


    url = "https://cn.morningstar.com/quickrank/default.aspx"


    # driver ||= Selenium::WebDriver.for :firefox

    # driver.navigate.to 'http://google.com'
    # driver.navigate.to url

    # puts driver.title


    # element = driver.find_element(name: 'ctl00$cphMain$ddlPageSite')
    # element.send_keys "Hello WebDriver!"
    # element.submit



    browser.goto url

    # browser.select_list(:id, "ctl00_cphMain_ddlPageSite").option(:text => "ACURA").when_present.select
    # browser.select_list(:id, "ctl00_cphMain_ddlPageSite").select_value("10000")
    # browser.select_list(id: "ctl00_cphMain_ddlPageSite").value

    browser.select_list(id: "ctl00_cphMain_ddlPageSite").select_value("1000");

    browser.trs(class: "gridItem").size
    # browser.trs(class: "gridAlternateItem").size



    begin
      File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{project.code}, Exception #{e}"
    end

    # doc = Nokogiri::HTML(browser.html)


    # doc.css("tr.gridItem").size
    # doc.css("tr.gridIgridAlternateItemtem").size

    browser.close
    headless.destroy
  end
end
