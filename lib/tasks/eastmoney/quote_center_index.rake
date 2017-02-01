namespace :eastmoney do
  desc "Task description"
  task :save_zs_data_to_dir => [:environment] do

    headless ||= Headless.new
    headless.start
    browser ||= Watir::Browser.new

    name_url = {
      Pinyin.t("沪深指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/index.html#zyzs_0_1",
      Pinyin.t("上海指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#15_0_1",
      Pinyin.t("深圳指数", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#25_0_1",
      Pinyin.t("指数成分", splitter: "_").to_sym => "http://quote.eastmoney.com/center/list.html#35_0_1"}

    name_url.each_pair do |name, url|
      # url = "http://quote.eastmoney.com/center/index.html#zyzs_0_1"
      browser.goto url
      browser.refresh


      fund_dir = Rails.public_path.join("quote/eastmoney/zyzs")
      FileUtils::mkdir_p(fund_dir)

      file_name_with_path = fund_dir.join("#{name}.html")


      begin
        File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= Exception #{e}"
      end
    end

    # zyzs = browser.div("#zyzs")

    browser.close
    headless.destroy
  end

  # 沪深指数
  desc "Task description"
  task :local_hu_shen_zhi_shu => [:environment] do
    name = "hu_shen_zhi_shu"

    fund_dir = Rails.public_path.join("quote/eastmoney/zyzs")
    # FileUtils::mkdir_p(fund_dir)

    file_name_with_path = fund_dir.join("#{name}.html")

    doc = Nokogiri::HTML(open(file_name_with_path).read);


    # begin 主要指数
    zyzs_ele = doc.css("#zyzs");

    zy_trs_ele = zyzs_ele.css("tr");

    zy_trs_ele.each do |tr_ele|
      tr_text = tr_ele.text

      if tr_text.blank?
        next
      end

      if tr_text =~ /代码/ && tr_text =~ /名称/
        next
      else
        # 代码
        code_ele = tr_ele.css("td")[0]
        # 名称
        name_ele = tr_ele.css("td")[1]

        # 最新价
        tr_ele.css("td")[2]
        # 涨跌额
        tr_ele.css("td")[3]
        # 涨跌幅
        tr_ele.css("td")[4]
        # 成交量(手)
        tr_ele.css("td")[5]
        # 成交额(万)
        tr_ele.css("td")[6]
        # 昨收
        tr_ele.css("td")[7]
        # 今开
        tr_ele.css("td")[8]
        # 最高
        tr_ele.css("td")[9]
        # 最低
        tr_ele.css("td")[10]
      end

      Quote.create(code: code_ele.text, name: name_ele.text)
    end
    # end 主要指数


    # begin 上海指数
    shtable_ele = doc.css("#shtable");

    sh_trs_ele = shtable_ele.css("tr");

    sh_trs_ele.each do |tr_ele|
      tr_text = tr_ele.text

      if tr_text.blank?
        next
      end

      if tr_text =~ /代码/ && tr_text =~ /名称/
        next
      else
        # 代码
        code_ele = tr_ele.css("td")[0]
        # 名称
        name_ele = tr_ele.css("td")[1]

        # 最新价
        tr_ele.css("td")[2]
        # 涨跌额
        tr_ele.css("td")[3]
        # 涨跌幅
        tr_ele.css("td")[4]
        # 成交量(手)
        tr_ele.css("td")[5]
        # 成交额(万)
        tr_ele.css("td")[6]
        # 昨收
        tr_ele.css("td")[7]
        # 今开
        tr_ele.css("td")[8]
        # 最高
        tr_ele.css("td")[9]
        # 最低
        tr_ele.css("td")[10]
      end

      Quote.create(code: code_ele.text, name: name_ele.text)
    end
    # end 上海指数


    # begin 深圳指数
    sztable_ele = doc.css("#sztable");

    sz_trs_ele = sztable_ele.css("tr");

    sz_trs_ele.each do |tr_ele|
      tr_text = tr_ele.text

      if tr_text.blank?
        next
      end


      if tr_text =~ /代码/ && tr_text =~ /名称/
        next
      else
        # 代码
        code_ele = tr_ele.css("td")[0]
        # 名称
        name_ele = tr_ele.css("td")[1]

        # 最新价
        tr_ele.css("td")[2]
        # 涨跌额
        tr_ele.css("td")[3]
        # 涨跌幅
        tr_ele.css("td")[4]
        # 成交量(手)
        tr_ele.css("td")[5]
        # 成交额(万)
        tr_ele.css("td")[6]
        # 昨收
        tr_ele.css("td")[7]
        # 今开
        tr_ele.css("td")[8]
        # 最高
        tr_ele.css("td")[9]
        # 最低
        tr_ele.css("td")[10]
      end

      Quote.create(code: code_ele.text, name: name_ele.text)
    end
    # end 深圳指数


    # begin 重点指数表现
    zdtable_ele = doc.css("#zdtable");

    zd_trs_ele = sztable_ele.css("tr");

    zd_trs_ele.each do |tr_ele|
      tr_text = tr_ele.text

      if tr_text.blank?
        next
      end

      if tr_ele.text =~ /代码/ && tr_ele.text =~ /名称/
        next
      else
        # 代码
        code_ele = tr_ele.css("td")[0]
        # 名称
        name_ele = tr_ele.css("td")[1]

        # 最新价
        tr_ele.css("td")[2]
        # 涨跌额
        tr_ele.css("td")[3]
        # 涨跌幅
        tr_ele.css("td")[4]
        # 成交量(手)
        tr_ele.css("td")[5]
        # 成交额(万)
        tr_ele.css("td")[6]
        # 昨收
        tr_ele.css("td")[7]
        # 今开
        tr_ele.css("td")[8]
        # 最高
        tr_ele.css("td")[9]
        # 最低
        tr_ele.css("td")[10]
      end

      Quote.create(code: code_ele.text, name: name_ele.text)
    end
    # end 重点指数表现
  end
end
