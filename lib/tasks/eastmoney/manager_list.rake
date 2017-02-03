require 'watir'
require 'headless'

namespace :eastmoney do
  desc "fetch company, managers. list"
  task :fetch_manager => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    (1..29).each do |page_number|
      p "page_number is #{page_number} =================="
      url = "http://fund.eastmoney.com/manager/default.html#dt14;mcreturnjson;ftall;pn50;pi#{page_number};scabbname;stasc" # our example

      browser.goto url
      browser.refresh


      el = browser.element :css => '#datalist'


      el.tbody.trs.each do |tr_ele|
        # 序号  姓名  所属公司  现任基金  累计从业时间  现任基金资产总规模 现任基金最佳回报
        name = tr_ele[1].text
        name_url = tr_ele[1].a.href

        company = tr_ele[2].text
        company_url = tr_ele[2].a.href
        catalog_id = company_url.split(/\.|\//)[-2]

        if catalog_id =~ /\d$/
          catalog = Catalog.find_by(code: catalog_id)
        else
          next
        end

        if catalog.blank?
          catalog = Catalog.create(code: catalog_id, short_name: company)

          unless catalog.persisted?
            next
          end
        end

        developer = Developer.find_or_create_by(name: name, eastmoney_url: name_url) do |x|
          x.catalog_id = catalog.id
        end

        CatalogDeveloper.find_or_create_by(catalog_id: catalog.id, developer_id: developer.id) do |cd|
          # cd.eastmoney_url = name_url
        end
      end
    end


    browser.close
    headless.destroy
  end

  desc "save_manager_list_to_dir. list"
  task :save_manager_list_to_dir => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    (1..29).each do |page_number|
      p "page_number is #{page_number} =================="
      url = "http://fund.eastmoney.com/manager/default.html#dt14;mcreturnjson;ftall;pn50;pi#{page_number};scabbname;stasc" # our example

      browser.goto url
      browser.refresh




      manager_list_dir = Rails.public_path.join("manager/eastmoney/list")
      FileUtils::mkdir_p(manager_list_dir)

      file_name_with_path = manager_list_dir.join("#{page_number}.html")


      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "=============Error page #{page_number}, Exception #{e}"
        break
      end
    end


    browser.close
    headless.destroy
  end
end
