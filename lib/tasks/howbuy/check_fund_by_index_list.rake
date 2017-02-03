namespace :howbuy do
  desc "check if all howbuy fund, our had or not."
  task :check_all_fund => [:environment, :save_funds_list_to_div] do
    # 数据源不同
    url = "http://www.howbuy.com/fund/fundnewissue.htm?pageType=index"

    sb ||= SpiderBase.new
    fetch_content = sb.page_for_url(url);

    doc = fetch_content.doc;


    fund_list_eles = doc.css("#tableData tr");
    puts "正在检测我们是否抓取了 howbuy 上所有基金，共 #{fund_list_eles.size} 支。"


    blank_funds = []

    fund_list_eles.each do |fund_item_ele|
      # 序号
      aa = fund_item_ele.css("td")[0]
      # 基金代码
      bb = fund_item_ele.css("td")[1]
      # 基金简称
      cc = fund_item_ele.css("td")[2]
      # 基金类型
      dd = fund_item_ele.css("td")[3]
      # 募集起始日
      ee = fund_item_ele.css("td")[4]
      # 募集终止日
      ff = fund_item_ele.css("td")[5]
      # 最高认购费率
      gg = fund_item_ele.css("td")[6]
      # 实际募集份额（亿）
      hh = fund_item_ele.css("td")[7]
      # 基金经理
      ii = fund_item_ele.css("td")[8]
      # 基金公司
      jj = fund_item_ele.css("td")[9]

      code = bb.css("a").text
      fund_name = cc.css("a").text

      beginning_at = ee.text
      endding_at = ff.text

      manager_name = ii.css("a").map(&:text)
      company_name = jj.css("a").text

      project = Project.find_by(code: code)

      if project.blank?
        blank_funds << "#{code}--#{fund_name}"
      end
    end

    if blank_funds.present?
      puts "如下 #{blank_funds.size} 支基金，我们还没有：\n#{blank_funds.join(', ')}"
    end

    blank_funds.each do |blank_fund|
      blank_fund_code = blank_fund.split("--").first
      blank_fund_name = blank_fund.split("--").last

      Project.create(code: blank_fund_code, name: blank_fund_name)
    end
  end

  desc "before check_all_fund, save funds list to dir."
  task :save_funds_list_to_div => [:environment] do


    url = "http://www.howbuy.com/fund/fundnewissue.htm?pageType=index"
    sb ||= SpiderBase.new
    fetch_content = sb.page_for_url(url);

    doc = fetch_content.doc;


    fund_list_eles = doc.css("#tableData tr");
    puts "抓取之前先保存一下到硬盘，共 #{fund_list_eles.size} 支。"


    newissue_dir = Rails.public_path.join("fund/howbuy/newissue")
    FileUtils::mkdir_p(newissue_dir)

    file_name_with_path = newissue_dir.join("index.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
    rescue Exception => e
      puts "=============Error #{e}"
    end


  end
end
