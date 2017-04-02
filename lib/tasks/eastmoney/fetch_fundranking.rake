namespace :fetch_fundranking do
  # save
  desc "Task description"
  task :task_name => [:environment] do
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

  # ==========================================
  
  # save
  desc "Task description"
  task :task_name => [:environment] do
    type_hash = {}


    fundranking_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_type")
    FileUtils::mkdir_p(fundranking_type_dir)


    # lof - lofNum: 163
    type_hash.merge!({'lof' => "LOF"})
    lof_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=lof&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.3811041024041757"

    # qdii - qdiiNum: 38
    type_hash.merge!({'qdii' => "QDII"})
    qdii_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.7745187205244815"

    # bb - bbNum: 136
    type_hash.merge!({'bb' => "保本型"})
    bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.879068990057011"

    # zs - zsNum: 417
    type_hash.merge!({'zs' => "指数型"})
    zs_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.25889147661044953"

    # zq - zqNum: 788
    type_hash.merge!({'zq' => "债券型"})
    zq_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.10790849419969883"

    # hh - hhNum: 1459
    type_hash.merge!({'hh' => "混合型"})
    # hh_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=hh&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.5845859028235414"
    hh_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=hh&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.9429390259395702"

    # gp - gpNum: 558
    type_hash.merge!({'gp' => "股票型"})
    # gp_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=gp&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.9013685990371794"
    gp_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=gp&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.21220137482541723"

    # all - allNum: 2979
    # url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.02517191375510186"
    url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.9034455260294147"

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

  # set
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

  # ==========================================

  # save
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    zq_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")
    FileUtils::mkdir_p(fundranking_sub_type_dir)


    # zq - zqNum: 788
    # type_hash.merge!({'zq' => "债券型"})
    # zq_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.10790849419969883"

    # 长期纯债
    zq_hash['zq_aa'] = "长期纯债"
    zq_aa_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=041|&tabSubtype=041,,,,,&pi=1&pn=10000&dx=0&v=0.7780775628965173"

    # 短期纯债
    zq_hash['zq_bb'] = "短期纯债"
    zq_bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=042|&tabSubtype=042,,,,,&pi=1&pn=10000&dx=0&v=0.4898762072633531"

    # 混合债基
    zq_hash['zq_cc'] = "混合债基"
    zq_cc_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=043|&tabSubtype=043,,,,,&pi=1&pn=10000&dx=0&v=0.764885198156583"

    # 定期开放债券
    zq_hash['zq_dd'] = "定期开放债券"
    zq_dd_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=008|&tabSubtype=008,,,,,&pi=1&pn=10000&dx=0&v=0.023816915230588265"

    # 可转债
    zq_hash['zq_ee'] = "可转债"
    zq_ee_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=045|&tabSubtype=045,,,,,&pi=1&pn=10000&dx=0&v=0.855446260533691"


    zq_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(type_with_url).read);

      if doc.present?
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      end
    end
  end

  # set
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    zq_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")
    # FileUtils::mkdir_p(fundranking_sub_type_dir)


    # zq - zqNum: 788
    # type_hash.merge!({'zq' => "债券型"})
    # zq_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-19&ed=2017-02-19&qdii=|&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.10790849419969883"

    # 长期纯债
    zq_hash['zq_aa'] = "长期纯债"
    # zq_aa_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=041|&tabSubtype=041,,,,,&pi=1&pn=10000&dx=0&v=0.7780775628965173"

    # 短期纯债
    zq_hash['zq_bb'] = "短期纯债"
    # zq_bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=042|&tabSubtype=042,,,,,&pi=1&pn=10000&dx=0&v=0.4898762072633531"

    # 混合债基
    zq_hash['zq_cc'] = "混合债基"
    # zq_cc_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=043|&tabSubtype=043,,,,,&pi=1&pn=10000&dx=0&v=0.764885198156583"

    # 定期开放债券
    zq_hash['zq_dd'] = "定期开放债券"
    # zq_dd_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=008|&tabSubtype=008,,,,,&pi=1&pn=10000&dx=0&v=0.023816915230588265"

    # 可转债
    zq_hash['zq_ee'] = "可转债"
    # zq_ee_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zq&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=045|&tabSubtype=045,,,,,&pi=1&pn=10000&dx=0&v=0.855446260533691"


    zq_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      # type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      if doc.present?
        # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }


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
          project.mold ||= zq_hash[type]
          project.tag_list.add(zq_hash[type])

          project.save
        end
      end
    end


  end

  # ==========================================

  # save
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    zs_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")
    FileUtils::mkdir_p(fundranking_sub_type_dir)


    zs_hash['zs_aa'] = "沪深指数"
    zs_aa_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=053|&tabSubtype=008,,053,,,&pi=1&pn=10000&dx=0&v=0.5984020150467795"


    zs_hash['zs_bb'] = "行业主题"
    zs_bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=054|&tabSubtype=008,,054,,,&pi=1&pn=10000&dx=0&v=0.23748602413453646"


    zs_hash['zs_cc'] = "大盘指数"
    zs_cc_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=01|&tabSubtype=008,,01,,,&pi=1&pn=10000&dx=0&v=0.8868640994675221"


    zs_hash['zs_dd'] = "中小盘指数"
    zs_dd_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=02,03|&tabSubtype=008,,02,03,,,&pi=1&pn=10000&dx=0&v=0.6325550057482414"


    zs_hash['zs_ee'] = "股票指数"
    zs_ee_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=001|&tabSubtype=008,,001,,,&pi=1&pn=10000&dx=0&v=0.9876891656438496"


    zs_hash['zs_ff'] = "债券指数"
    zs_ff_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=003|&tabSubtype=008,,003,,,&pi=1&pn=10000&dx=0&v=0.14238717862088213"



    zs_hash['zs_gg'] = "被动指数型"
    zs_gg_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=01|051&tabSubtype=008,,01,051,,&pi=1&pn=10000&dx=0&v=0.7628527119497697"

    zs_hash['zs_hh'] = "增强指数型"
    zs_hh_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=zs&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=01|052&tabSubtype=008,,01,052,,&pi=1&pn=10000&dx=0&v=0.32686434524501595"



    zs_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(type_with_url).read);

      if doc.present?
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      end
    end
  end

  # set
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    zs_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")


    zs_hash['zs_aa'] = "沪深指数"

    zs_hash['zs_bb'] = "行业主题"

    zs_hash['zs_cc'] = "大盘指数"

    zs_hash['zs_dd'] = "中小盘指数"

    zs_hash['zs_ee'] = "股票指数"

    zs_hash['zs_ff'] = "债券指数"


    zs_hash['zs_gg'] = "被动指数型"

    zs_hash['zs_hh'] = "增强指数型"


    zs_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      # type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      if doc.present?
        # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }


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
          project.mold ||= zs_hash[type]
          project.tag_list.add(zs_hash[type])

          project.save
        end
      end
    end


  end

  # ==========================================

  # save
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    bb_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")
    FileUtils::mkdir_p(fundranking_sub_type_dir)


    bb_hash['bb_aa'] = "保本金"
    bb_aa_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=|1&tabSubtype=008,,01,052,,1&pi=1&pn=10000&dx=0&v=0.8573896300785344"

    bb_hash['bb_bb'] = "保本金和利息"
    bb_bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=|2&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.5467445318907391"

    bb_hash['bb_cc'] = "保本金、利息和费用"
    bb_cc_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=|3&tabSubtype=008,,01,052,,3&pi=1&pn=10000&dx=0&v=0.48484668802702724"

    bb_hash['bb_dd'] = "保本金和费用"
    bb_dd_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=|4&tabSubtype=008,,01,052,,4&pi=1&pn=10000&dx=0&v=0.6778723283431438"

    bb_hash['bb_ee'] = "保本金和费用"
    bb_ee_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=bb&rs=&gs=0&sc=zzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=|4&tabSubtype=008,,01,052,,4&pi=1&pn=10000&dx=0&v=0.6778723283431438"


    bb_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(type_with_url).read);

      if doc.present?
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      end
    end
  end

  # set
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    bb_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")


    bb_hash['bb_aa'] = "保本金"

    bb_hash['bb_bb'] = "保本金和利息"

    bb_hash['bb_cc'] = "保本金、利息和费用"

    bb_hash['bb_dd'] = "保本金和费用"

    bb_hash['bb_ee'] = "保本金和费用"


    bb_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      # type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      if doc.present?
        # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }


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
          project.mold ||= bb_hash[type]
          project.tag_list.add(bb_hash[type])

          project.save
        end
      end
    end

  end

  # ==========================================

  # save
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    qdii_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")
    FileUtils::mkdir_p(fundranking_sub_type_dir)


    qdii_hash['qdii_aa'] = "全球股票"
    qdii_aa_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=311&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.8879397331603069"

    qdii_hash['qdii_bb'] = "亚太股票"
    qdii_bb_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=312&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.4959411649751735"

    qdii_hash['qdii_cc'] = "大中华区股票"
    qdii_cc_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=313&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.0813733939504051"

    qdii_hash['qdii_dd'] = "新兴市场股票"
    qdii_dd_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=314&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.29904380173511624"

    qdii_hash['qdii_ee'] = "金砖国家股票"
    qdii_ee_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=315&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.17036911856473025"

    qdii_hash['qdii_ff'] = "成熟市场股票"
    qdii_ff_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=316&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.4546322621679868"

    qdii_hash['qdii_gg'] = "美国股票"
    qdii_gg_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=317&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.9818678170227555"

    qdii_hash['qdii_hh'] = "全球指数"
    qdii_hh_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=318&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.3354629496927213"

    qdii_hash['qdii_ii'] = "QDII-ETF联接"
    qdii_ii_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=319&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.5058483061919661"

    qdii_hash['qdii_jj'] = "股债混合"
    qdii_jj_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=320&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.03526915703688682"

    qdii_hash['qdii_kk'] = "债券"
    qdii_kk_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=330&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.5007691352437695"

    qdii_hash['qdii_ll'] = "商品"
    qdii_ll_url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=qdii&rs=&gs=0&sc=jnzf&st=desc&sd=2016-02-20&ed=2017-02-20&qdii=340&tabSubtype=008,,01,052,,2&pi=1&pn=10000&dx=0&v=0.2021891225397705"


    qdii_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(type_with_url).read);

      if doc.present?
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      end
    end
  end

  # set
  desc "Task description"
  task :task_name => [:dependent, :tasks] do

    qdii_hash = {}


    fundranking_sub_type_dir = Rails.public_path.join("fund/eastmoney/fundranking_sub_type")


    qdii_hash['qdii_aa'] = "全球股票"

    qdii_hash['qdii_bb'] = "亚太股票"

    qdii_hash['qdii_cc'] = "大中华区股票"

    qdii_hash['qdii_dd'] = "新兴市场股票"

    qdii_hash['qdii_ee'] = "金砖国家股票"

    qdii_hash['qdii_ff'] = "成熟市场股票"

    qdii_hash['qdii_gg'] = "美国股票"

    qdii_hash['qdii_hh'] = "全球指数"

    qdii_hash['qdii_ii'] = "QDII-ETF联接"

    qdii_hash['qdii_jj'] = "股债混合"

    qdii_hash['qdii_kk'] = "债券"

    qdii_hash['qdii_ll'] = "商品"


    qdii_hash.each_pair do |type, cn_tag|
      file_name_with_path = fundranking_sub_type_dir.join("#{type}.html")

      # type_with_url = eval("#{type}_url")
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      if doc.present?
        # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }


        result_hash = eval(doc.css("body").text.strip.gsub(/^var/, ""));
        result_hash.keys
        # => [:datas, :allRecords, :pageIndex, :pageNum, :allPages, :allNum, :gpNum, :hhNum, :zqNum, :zsNum, :bbNum, :qdiiNum, :etfNum, :lofNum]
        first_data = result_hash[:datas][0]

        if first_data.blank?
          puts "no data ==================="
          next
        end

        result_hash[:datas][0].split(",").size
        result_hash[:datas][0].split(",")
        # 基金代码,    基金简称,           基金首字母拼音, 净值更新日期   单位净值    累计净值   日增长率   近1周      近1月      近3月     近6月       近1年       近2年     近3年 今年来     成立来   成立日期       1折        手续费（无打折）手续费（打折） 1折 手续费 1折 管理费
        # ["000934", "国富大中华精选混合", "GFDZHJXHH", "2017-02-16", "1.0580", "1.0580", "0.1894", "2.1236", "8.8477", "7.0850", "13.0342", "40.6915", "7.4112", "", "10.6695", "5.80", "2015-02-03", "1", "", "1.50%", "0.15%", "1", "0.15%", "1"]

        fund_codes = result_hash[:datas].map{|x| x.split(",").first }

        Project.where(code: fund_codes).map do |project|
          project.mold ||= qdii_hash[type]
          project.tag_list.add(qdii_hash[type])

          project.save
        end
      end
    end

  end

  # ==========================


  desc "Task description"
  task :set_all_fund_day_net_worth => [:environment] do
    sd = 1.year.ago.strftime("%F")
    ed = Date.today.strftime("%F")

    # url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=zzf&st=desc&sd=#{sd}&ed=#{ed}&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=1&v=0.19890163023559482"
    url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=zzf&st=desc&sd=#{sd}&ed=#{ed}&qdii=&tabSubtype=,,,,,&pi=1&pn=10000&dx=0&v=0.11866221272740218"


    doc = Nokogiri::HTML(open(url).read);


    if doc.present?
      # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }

      result_hash = eval(doc.css("body").text.strip.gsub(/^var/, ""));
      result_hash.keys
      # => [:datas, :allRecords, :pageIndex, :pageNum, :allPages, :allNum, :gpNum, :hhNum, :zqNum, :zsNum, :bbNum, :qdiiNum, :etfNum, :lofNum]
      first_data = result_hash[:datas][0]

      if first_data.blank?
        puts "no data ==================="
      end

      result_hash[:datas][0].split(",").size
      result_hash[:datas][0].split(",")
      # 基金代码,    基金简称,           基金首字母拼音, 净值更新日期   单位净值    累计净值   日增长率   近1周      近1月      近3月     近6月       近1年       近2年     近3年 今年来     成立来   成立日期       1折        手续费（无打折）手续费（打折） 1折 手续费 1折 管理费
      # ["000934", "国富大中华精选混合", "GFDZHJXHH", "2017-02-16", "1.0580", "1.0580", "0.1894", "2.1236", "8.8477", "7.0850", "13.0342", "40.6915", "7.4112", "", "10.6695", "5.80", "2015-02-03", "1", "", "1.50%", "0.15%", "1", "0.15%", "1"]

      # fund_codes = result_hash[:datas].map{|x| x.split(",").first }

      result_hash[:datas].each_with_index do |result_string, index|
        result_array = result_string.split(",")

        code = result_array[0]
        record_at = result_array[3]
        dwjz = result_array[4].to_f
        ljjz = result_array[5].to_f
        accnav = result_array[6].to_f.round(2)

        project = Project.find_by(code: code)

        if project.present?
          puts "project #{code}, index #{index} ========="

          project.net_worths.create(record_at: record_at,
                                    dwjz: dwjz,
                                    ljjz: ljjz,
                                    accnav: accnav)
        end
      end
    end
  end
end






