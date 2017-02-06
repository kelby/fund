namespace :sina do
  namespace : do
  desc "Task description"
  task :update_all_open_fund_net_worth => [:environment] do

    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    url = "http://vip.stock.finance.sina.com.cn/fund_center/data/jsonp.php/IO.XSRV2.CallbackList['32sd$CbNssSUuKmO']/NetValueReturn_Service.NetValueReturnOpen?page=1&num=5500&sort=form_year&asc=0&ccode=&type2=0&type3="


    # 获取
    browser.goto url


    net_worth_dir = Rails.public_path.join("fund/sina/all_net_worth")
    FileUtils::mkdir_p(net_worth_dir)

    file_name_with_path = net_worth_dir.join("index.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{e}"
    end

    browser.close
    headless.destroy
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    net_worth_dir = Rails.public_path.join("fund/sina/all_net_worth")
    file_name_with_path = net_worth_dir.join("index.html")


    doc = Nokogiri::HTML(open(file_name_with_path).read);

    body_text = doc.css("body").text;
    dup_body_text = body_text;


    valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0];
    json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "");

    result_hash = eval(json_str.as_json);
    result_hash.keys

    net_worth_array = result_hash[:data];
    net_worth_array.size

    # => {:symbol=>"002534", # 基金代码
    # :sname=>"华安稳固收益债券A", # 基金名称
    # :per_nav=>"1.563",
    # :total_nav=>"1.563",
    # :three_month=>39.9284, # 近三个月(%)
    # :six_month=>41.065, # 近六个月(%)
    # :one_year=>"--", # 近一年(%)
    # :form_year=>144.8563, # 今年以来(%)
    # :form_start=>42.7397, # 成立以来(%)
    # :name=>"华安稳固收益债券A",
    # :zmjgm=>"",
    # :clrq=>"2016-03-22 00:00:00", # 成立日期
    # :jjjl=>"郑可成、石雨欣", # 基金经理
    # :dwjz=>"1.563", # 单位净值
    # :ljjz=>"1.563", # 累计净值
    # :jzrq=>"2017-02-03 00:00:00", # 净值日期
    # :zjzfe=>190105000,
    # :jjglr_code=>"80000228"} # 基金管理人
  end
end
