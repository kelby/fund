desc "fetch company datas"
task :fetch_company_data => [:environment] do
  headless = Headless.new
  headless.start
  browser = Watir::Browser.new

  Catalog.where.not(code: [nil, '']).each_with_index do |catalog, index|
    url = "http://fund.eastmoney.com/company/#{catalog.code}.html"
    puts "Fetch company #{catalog.code} =========== index #{index}"

    browser.goto url
    browser.refresh

    table_eles = browser.tables(class: 'data_table')

    table_eles.each do |table_ele|
      if table_ele.text.blank?
        next
      end

      # table_ele.t_bodies.each do |tbody_ele|
        table_ele.rows.each do |tr_ele|
          first_td_ele = tr_ele.tds[0]

          if first_td_ele.blank? || first_td_ele.text.blank?
            next
          end

          puts "first_td_ele text is #{first_td_ele.text}"

          # begin
          if first_td_ele.a.exists?
            a_ele = first_td_ele.a
          else
            next
          end
          # rescue Exception => e
            # next
          # end

          if a_ele.blank? || a_ele.text.blank?
            next
          end

          name = a_ele.text
          _project_url = a_ele.href
          code = _project_url.split(/\.|\//)[-2]


          unless code =~ /\d$/
            next
          end


          puts "For fund #{name} ........."
          catalog.projects.find_or_create_by(name: name, code: code)
        end
      # end
    end

    sleep(rand(1..10.0))
  end

  browser.close
  headless.destroy
end