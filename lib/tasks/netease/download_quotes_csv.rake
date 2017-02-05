# require 'open-uri'

namespace :netease do
  desc "Townload main index reports, stock from netease url."
  task :download_quotes_csv => [:environment] do

    fundranking_dir = Rails.public_path.join("stock/netease/chddata")
    FileUtils::mkdir_p(fundranking_dir)


    # 抓取一些主要指数的数据："http://quotes.money.163.com/old/#query=main"
    %W(000001
    000002
    000003
    000016
    000300
    399001
    399002
    399003
    399006
    399102
    399106).each do |code|
      index_repot = IndexReport.find_by(code: code)

      if index_repot.blank?
        next
      end

      stock = Stock.find_by(code: code)

      if stock.blank?
        stock = Stock.create(code: code, name: index_repot.name)
      end

      # ...

      if code =~ /^0/
        format_code = '0' + code
      elsif code =~ /^3/
        format_code = '1' + code
      else
        next
      end

      start_date = index_repot.set_up_at.strftime("%Y%m%d")
      end_date = Time.now.strftime("%Y%m%d")

      url = "http://quotes.money.163.com/service/chddata.html?code=#{format_code}&start=#{start_date}&end=#{end_date}&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;VATURNOVER"

      file_name_with_path = fundranking_dir.join("#{code}.csv")

      open(file_name_with_path, 'wb') do |file|
        file << open( url ).read
      end

      # 可考虑使用新线程执行代码
      # Thread.new do
        # code here...
      # end

    end


  end
end
