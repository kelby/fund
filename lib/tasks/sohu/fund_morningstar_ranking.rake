require 'rest-client'
require 'nokogiri'

namespace :sohu do
  desc "Fetch morningstar fund rankings"
  task :save_fund_ranking_to_dir => [:environment] do

    url = "http://q.fund.sohu.com/r/cxo.php"

    # 最近一期
    fundranking_dir = Rails.public_path.join("fund/sohu/fundranking")
    FileUtils::mkdir_p(fundranking_dir)

    # 历史数据
    fund_ranking_dir = Rails.public_path.join("fund/sohu/fund_ranking")
    FileUtils::mkdir_p(fund_ranking_dir)

    response = RestClient.post url, {}

    if response.code == 200
      doc = Nokogiri::HTML(response.body);

      file_name_with_path = fundranking_dir.join("latest.html")

      puts "Fetch fundranking from #{url}"

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{catalog.code}"
      end
    end


    date_options = doc.css("select#tdate").css("option").map(&:text);
    date_options.size

    # 开发时测试
    # date_options.first(3).each do |date, index|
      # index ||= 0

    # 断点续传
    # date_options = date_options.select{|x| x.to_time <= '2014-04-18'.to_time }
    # date_options.size

    date_options.each_with_index do |date, index|
      file_name_with_path = fund_ranking_dir.join("#{date}.html")

      # 已经抓取保存到硬盘的历史数据，不必重新抓取
      if File.exists?(file_name_with_path)
        next
      end

      response = RestClient.post url, {tdate: date}
      # puts "#{date} ============= 000"

      # if response.present? && !response.code.valid_encoding?
      #   response.code = response.code.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      # end

      # if response.present? && response.code == 200
        # puts "#{date} ============= 111111111"
        _doc = Nokogiri::HTML(response.body);
        # puts "#{date} ============= 111"


        # puts _doc.css("select#tdate").attr('value')
        if _doc.css("select#tdate").blank?
          break
        end

        puts "Fetch fund_ranking from #{url}, date #{date} ====== #{index}"

        begin
          # puts "#{date} ============= 222"
          File.open(file_name_with_path, 'w') { |file| file.write(_doc.to_html) }
        rescue Exception => e
          puts "=============Error date #{date}, Exception #{e}"
        end
      # end

      response = nil

      # sleep( rand(0.001..1) )
    end

  end
end

