require 'watir'
require 'headless'

desc "fetch company, manages."
task :fetch_manager => [:environment] do

  # browser = Watir::Browser.new
  # browser.goto 'google.com'
  # browser.text_field(title: 'Search').set 'Hello World!'
  # browser.button(type: 'submit').click

  # puts browser.title
  # # => 'Hello World! - Google Search'
  # browser.close


  headless = Headless.new
  headless.start
  browser = Watir::Browser.new

  (1..29).each do |page_number|
    p page_number
    url = "http://fund.eastmoney.com/manager/default.html#dt14;mcreturnjson;ftall;pn50;pi#{page_number};scabbname;stasc" # our example

    browser.goto url
    el = browser.element :css => '#datalist'
    # puts el.text

    el.tbody.each do |tr_ele|
      # 序号  姓名  所属公司  现任基金  累计从业时间  现任基金资产总规模 现任基金最佳回报
      name = tr_ele[1].text
      name_url = tr_ele[1].a.href

      company = tr_ele[2].text
      company_url = tr_ele[2].a.href
      company_id = company_url.split(/\.|\//)[-2]

      if company_id =~ /\d$/
        catalog = Catalog.find_by(code: company_id)
      else
        next
      end

      if catalog.blank?
        catalog = Catalog.create(code: company_id, short_name: company)
      end

      developer = Developer.create(name: name)

      CatalogDeveloper.find_or_create_by(catalog_id: catalog.id, developer_id: developer.id) do |cd|
        cd.eastmoney_url = name_url
      end
    end
  end


  browser.close
  headless.destroy
end