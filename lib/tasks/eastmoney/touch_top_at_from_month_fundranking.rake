namespace :eastmoney do
  desc "Task description"
  task :touch_top_at_from_month_fundranking => [:environment] do
    sd = 1.years.ago.strftime("%F")
    ed = Time.now.strftime("%F")
    url = "http://fund.eastmoney.com/data/rankhandler.aspx?op=ph&dt=kf&ft=all&rs=&gs=0&sc=1yzf&st=desc&sd=#{sd}&ed=#{ed}&qdii=&tabSubtype=,,,,,&pi=1&pn=200&dx=1&v=0.5072171459226815"

    doc = Nokogiri::HTML(open(url).read);

    if doc.present?
      result_hash = eval(doc.css("body").text.strip.gsub(/^var/, ""));
      result_hash.keys
      # => [:datas, :allRecords, :pageIndex, :pageNum, :allPages, :allNum, :gpNum, :hhNum, :zqNum, :zsNum, :bbNum, :qdiiNum, :etfNum, :lofNum]
      result_hash[:datas][0]
      result_hash[:datas][0].split(",").size
      result_hash[:datas][0].split(",")
      # 基金代码,    基金简称,           基金首字母拼音, 净值更新日期   单位净值    累计净值   日增长率   近1周      近1月      近3月     近6月       近1年       近2年     近3年 今年来     成立来   成立日期       1折        手续费（无打折）手续费（打折） 1折 手续费 1折 管理费
      # ["000934", "国富大中华精选混合", "GFDZHJXHH", "2017-02-16", "1.0580", "1.0580", "0.1894", "2.1236", "8.8477", "7.0850", "13.0342", "40.6915", "7.4112", "", "10.6695", "5.80", "2015-02-03", "1", "", "1.50%", "0.15%", "1", "0.15%", "1"]

      fund_codes = result_hash[:datas].map{|x| x.split(",")[0] }
      fund_month_yield = result_hash[:datas].map{|x| x.split(",")[8] }

      code_yield_hash = Hash[fund_codes.zip fund_month_yield]

      Project.where(code: fund_codes).map do |project|
        Project.delay_for(code_yield_hash[project.code].to_f).touch_up_top_at(project.id)
      end
    end
  end
end
