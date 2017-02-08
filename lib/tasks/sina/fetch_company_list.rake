namespace :sina do
  # http://vip.stock.finance.sina.com.cn/fund_center/index.html#jjgs
  # 获取数据
  desc "get sina fund company list"
  task :fetch_company_list => [:environment] do
    # 在如下页面点击 ajax 事件
    # "http://money.finance.sina.com.cn/fund_center/index.html#jjgs"
    # 在网络请求里有类似如下请求
    # "http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/IO.XSRV2.CallbackList['72k6lLGYRRUqbPOC']/FundRank_Service.getFundCompanyList?page=2&num=40&sort=&type=jjglr&asc=1&ccode="
    # 把 page 和 num 改一下就满足我们需求了！

    headless = Headless.new
    headless.start
    browser = Watir::Browser.new


    url = "http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/IO.XSRV2.CallbackList['72k6lLGYRRUqbPOC']/FundRank_Service.getFundCompanyList?page=1&num=150&sort=&type=jjglr&asc=1&ccode="

    # 获取
    browser.goto url


    compnay_list_dir = Rails.public_path.join("company/sina/list")
    FileUtils::mkdir_p(compnay_list_dir)

    file_name_with_path = compnay_list_dir.join("index.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{e}"
    end
  end


  # 处理数据
  desc "logic create company after fetch_company_list"
  task :logic_create_company => [:environment] do
    compnay_list_dir = Rails.public_path.join("company/sina/list")
    file_name_with_path = compnay_list_dir.join("index.html")


    doc = Nokogiri::HTML(open(file_name_with_path).read);

    body_text = doc.css("body").text;
    dup_body_text = body_text;


    # regexp = /\{start_grab_entries\}(.*?)\{end_grab_entries\}/m
    # {FundCompanyId:"80199117",FundCompanyName:"华润元大基金管理有限公司",FundNum_OF:15,FundShare_Open:"23.36",FundNum_CF:0,FundShare_Close:"--",FundNum_Total:15,FundShare_Total:"23.36"}

    valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0]
    json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "")

    # 危险操作，请先大致查看页面内容，确认是安全的！
    # 页面内容奇怪，不能直接使用 JSON.parse
    result_hash = eval(json_str.as_json)
    company_array = result_hash[:data]

    company_array.each do |company_hash|
      # {:FundCompanyId=>"80199117",
      # :FundCompanyName=>"华润元大基金管理有限公司", # 公司名称
      # :FundNum_OF=>15, # 开放式(只)
      # :FundShare_Open=>"23.36", # 开放式份额(亿份)
      # :FundNum_CF=>0, # 封闭式(只)
      # :FundShare_Close=>"--", # 封闭式份额(亿份)
      # :FundNum_Total=>15, # 总数(只)
      # :FundShare_Total=>"23.36"} # 总份额(亿份)

      Catalog.find_or_create_by(name: company_hash[:FundCompanyName]) do |company|
        company.sina_code = company_hash[:FundCompanyId]
      end
    end
  end

  desc "logic set company sina_code from fetch_company_list"
  task :logic_set_comapny_sina_code => [:environment] do
    compnay_list_dir = Rails.public_path.join("company/sina/list")
    file_name_with_path = compnay_list_dir.join("index.html")


    doc = Nokogiri::HTML(open(file_name_with_path).read);

    body_text = doc.css("body").text;
    dup_body_text = body_text;


    # regexp = /\{start_grab_entries\}(.*?)\{end_grab_entries\}/m
    # {FundCompanyId:"80199117",FundCompanyName:"华润元大基金管理有限公司",FundNum_OF:15,FundShare_Open:"23.36",FundNum_CF:0,FundShare_Close:"--",FundNum_Total:15,FundShare_Total:"23.36"}

    valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0];
    json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "");

    # 危险操作，请先大致查看页面内容，确认是安全的！
    # 页面内容奇怪，不能直接使用 JSON.parse
    result_hash = eval(json_str.as_json);
    result_hash.keys

    company_array = result_hash[:data];
    company_array.size

    company_array.each do |company_hash|
      # {:FundCompanyId=>"80199117",
      # :FundCompanyName=>"华润元大基金管理有限公司", # 公司名称
      # :FundNum_OF=>15, # 开放式(只)
      # :FundShare_Open=>"23.36", # 开放式份额(亿份)
      # :FundNum_CF=>0, # 封闭式(只)
      # :FundShare_Close=>"--", # 封闭式份额(亿份)
      # :FundNum_Total=>15, # 总数(只)
      # :FundShare_Total=>"23.36"} # 总份额(亿份)

      catalog = Catalog.find_by(name: company_hash[:FundCompanyName])
      catalog.sina_code = company_hash[:FundCompanyId]

      if catalog.changed?
        catalog.save
      end
    end
  end
end