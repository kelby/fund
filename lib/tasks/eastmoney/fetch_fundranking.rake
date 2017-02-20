namespace :fetch_fundranking do
  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    url = "http://fund.eastmoney.com/data/fundranking.html#tlof;c0;r;szzf;pn10000;ddesc;qsd20160219;qed20170219;qdii;zq;gg;gzbd;gzfs;bbzt;sfbb"

    headless = Headless.new
    headless.start
    browser = Watir::Browser.new



    browser.goto url
    # browser.refresh



    manager_dir = Rails.public_path.join("fund/eastmoney/fundranking")
    FileUtils::mkdir_p(manager_dir)

    # yourfile = Rails.public_path.join("company/#{catalog.code}.html")
    file_name_with_path = manager_dir.join("lof.html")


    begin
      File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
    rescue Exception => e
      puts "=============Error #{e}"
    end
  end

  

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    type_hash = {}


    fundranking_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_type")
    FileUtils::mkdir_p(fundranking_type_dir)


    # lof - lofNum: 163
    type_hash.merge!({'lof' => "LOF"})
    lof_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=lof&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.3811041024041757"

    # qdii - qdiiNum: 38
    type_hash.merge!({'qdii' => "QDII"})
    qdii_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.7745187205244815"

    # bb - bbNum: 136
    type_hash.merge!({'bb' => "保本型"})
    bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.879068990057011"

    # zs - zsNum: 417
    type_hash.merge!({'zs' => "指数型"})
    zs_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.25889147661044953"

    # zq - zqNum: 788
    type_hash.merge!({'zq' => "债券型"})
    zq_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.10790849419969883"

    # hh - hhNum: 1459
    type_hash.merge!({'hh' => "混合型"})
    hh_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=hh&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.5845859028235414"

    # gp - gpNum: 558
    type_hash.merge!({'gp' => "股票型"})
    gp_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=gp&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.9013685990371794"

    # all - allNum: 2979
    url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.02517191375510186"

    # etf
    # null

    type_array = %W(lof qdii bb zs zq hh gp)

    type_array.each do |type|
      file_name_with_path = fundranking_type_dir.join("#{type}.html")

      type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(type_with_url).read);

      if doc.present?
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      end
    end

    # doc = Nokogiri::HTML(open(url).read);
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    type_hash = {}


    fundranking_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_type")
    # FileUtils::mkdir_p(fundranking_type_dir)

    type_hash.merge!({'lof' => "LOF"})

    type_hash.merge!({'qdii' => "QDII"})

    type_hash.merge!({'bb' => "保本型"})

    type_hash.merge!({'zs' => "指数型"})

    type_hash.merge!({'zq' => "债券型"})

    type_hash.merge!({'hh' => "混合型"})

    type_hash.merge!({'gp' => "股票型"})

    type_array = %W(lof qdii bb zs zq hh gp)


    type_array.each do |type|
      file_name_with_path = fundranking_type_dir.join("#{type}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      if doc.present?
        result_hash = eval(doc.css("body").text.strip.gsub(/^var/, ""));
        result_hash.keys
        # => [:datas, :allRecords, :pageIndex, :pageNum, :allPages, :allNum, :gpNum, :hhNum, :zqNum, :zsNum, :bbNum, :qdiiNum, :etfNum, :lofNum]
        result_hash[:datas][0]
        result_hash[:datas][0].split(",").size
        result_hash[:datas][0].split(",")
        # 基金代码,    基金简称,           基金首字母拼音, 净值更新日期   单位净值    累计净值   日增长率   近1周      近1月      近3月     近6月       近1年       近2年     近3年 今年来     成立来   成立日期       1折        手续费（无打折）手续费（打折） 1折 手续费 1折 管理费
        # ["000934", "国富大中华精选混合", "GFDZHJXHH", "2017-02-16", "1.0580", "1.0580", "0.1894", "2.1236", "8.8477", "7.0850", "13.0342", "40.6915", "7.4112", "", "10.6695", "5.80", "2015-02-03", "1", "", "1.50%", "0.15%", "1", "0.15%", "1"]

        fund_codes = result_hash[:datas].map{|x| x.split(",").first }

        Project.where(code: fund_codes).map do |project|
          project.mold ||= type_hash[type]
          project.tag_list.add(type_hash[type])

          project.save
        end
      end
    end
  end

end






