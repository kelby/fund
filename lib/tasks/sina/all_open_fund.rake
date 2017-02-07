namespace :sina do
  desc "get all open fund data. list"
  task :all_open_fund => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new


    num = 1000

    1.upto(6) do |page|
      url = "http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/IO.XSRV2.CallbackList['Wzf0HDEwjEBWI$Jh']/NetValueReturn_Service.NetValueReturnOpen?page=#{page}&num=#{num}&sort=form_year&asc=0&ccode=&type2=0&type3="

      browser.goto url


      all_open_fund_dir = Rails.public_path.join("fund/sina/all_open/list")
      FileUtils::mkdir_p(all_open_fund_dir)

      file_name_with_path = all_open_fund_dir.join("#{page}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "=============Error #{e}"
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    all_sina_fund_codes = []

    1.upto(6) do |page|
      all_open_fund_dir = Rails.public_path.join("fund/sina/all_open/list")
      file_name_with_path = all_open_fund_dir.join("#{page}.html")


      doc = Nokogiri::HTML(open(file_name_with_path).read);

      body_text = doc.css("body").text;
      dup_body_text = body_text;


      valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0];
      json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "");

      # 危险操作，请先大致查看页面内容，确认是安全的！
      # 页面内容奇怪，不能直接使用 JSON.parse
      result_hash = eval(json_str.as_json);
      result_hash.keys

      data_array = result_hash[:data];
      data_array.size

      data_array[0]
      data_array[1]

      data_array[1].keys

      fund_codes = data_array.map{|data| data[:symbol].try(:to_s) };


      all_sina_fund_codes += fund_codes;
      # catalog_codes = Catalog.pluck(:code);
    end

    db_fund_codes = Project.pluck(:code);


    (all_sina_fund_codes - db_fund_codes).size

    (db_fund_codes - all_sina_fund_codes).size
    # => 928

    (all_sina_fund_codes - db_fund_codes)
    # => ["519996", "519994"]

    (db_fund_codes - all_sina_fund_codes)

    # {symbol:217015,
    #   sname:"招商全球资源股票(QDII)",
    #   per_nav:"1.004",
    #   total_nav:"1.004",
    #   three_month:6.92226,
    #   six_month:7.95699,
    #   one_year:29.0488,
    #   form_year:104.91118,
    #   form_start:0.4,
    #   name:"招商全球资源股票(QDII)",
    #   zmjgm:"55299.3",
    #   clrq:"2010-03-25 00:00:00",
    #   jjjl:"白海峰",
    #   dwjz:"1.004",
    #   ljjz:"1.004",
    #   jzrq:"2017-01-26 00:00:00",
    #   zjzfe:37089300,
    #   jjglr_code:"80036782"}
  end
end
