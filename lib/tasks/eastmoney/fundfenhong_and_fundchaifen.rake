namespace :eastmoney do
  desc "Task description"
  task :fundfenhong => [:dependent, :tasks] do
    sb = SpiderBase.new
    fundfenhong_dir = Rails.public_path.join("fund/eastmoney/fundfenhong_with_paginate")
    FileUtils::mkdir_p(fundfenhong_dir)

    1.upto(78).each_with_index do |page, index|
      url = "http://fund.eastmoney.com/Data/funddataIndex_Interface.aspx?dt=8&page=#{page}&rank=FSRQ&sort=desc&gs=&ftype=&year="




      fetch_content = sb.page_for_url(url);
      puts "Fetch data from #{url} =========== #{index}"


      doc = fetch_content.doc;

      file_name_with_path = fundfenhong_dir.join("#{page}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "============= Exception #{e}"
        break
      end
    end


  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    # sb = SpiderBase.new
    fundfenhong_dir = Rails.public_path.join("fund/eastmoney/fundfenhong_with_paginate")

    blank_net_worths = []
    blank_projects = []

    1.upto(78).each_with_index do |page, index|
      puts "=== === === set page #{page} === === ==="
      file_name_with_path = fundfenhong_dir.join("#{page}.html")

      # fetch_content = sb.page_for_url(url);

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      result_text = doc.css("body").text.gsub(/^(var)|( var)|(var )|( var )/, "");

      pageinfo = eval(result_text.split(";")[0])

      # 基金代码  基金简称  权益登记日 除息日期  分红(元/份) 分红发放日 操作(是,否)
      jjfh_data = eval(result_text.split(";")[1])

      jjfh_jjgs = eval(result_text.split(";")[2])
      jjfh_year = eval(result_text.split(";")[3])
      jjfh_ftype = eval(result_text.split(";")[4])
        # eval(result_text)
      # end

      jjfh_data.each do |fund_fen_hong_data_array|
        code = fund_fen_hong_data_array[0]
        name = fund_fen_hong_data_array[1]
        register_at = fund_fen_hong_data_array[2]
        ex_dividend_at = fund_fen_hong_data_array[3]
        bonus = fund_fen_hong_data_array[4]
        dividend_distribution_at = fund_fen_hong_data_array[5]
        # 略 = fund_fen_hong_data_array[6]

        project = Project.find_by(code: code)

        if project.present?
          net_worth = project.net_worths.find_by(record_at: ex_dividend_at.to_time)

          if net_worth.present?
            net_worth_id = net_worth.id
          else
            puts "project #{code} exists, but date #{ex_dividend_at}, has not net_worths. ==========="
            blank_net_worths << "#{name}-#{code}-#{ex_dividend_at}"
            # next
          end

          # ...
          if net_worth.present?
            project.fund_fen_hongs.create(
              net_worth_id: net_worth_id,
              register_at: register_at.to_time,
              ex_dividend_at: ex_dividend_at.to_time,
              bonus: bonus.to_f,
              dividend_distribution_at: dividend_distribution_at.to_time)
          else
            project.fund_fen_hongs.create(
              register_at: register_at.to_time,
              ex_dividend_at: ex_dividend_at.to_time,
              bonus: bonus.to_f,
              dividend_distribution_at: dividend_distribution_at.to_time)
          end
        else
          blank_projects << "#{name}-#{code}"
        end
      end
    end

    puts "------------------------------------------\n\n"

    puts "blank_net_worths size #{blank_net_worths.size}\n"
    puts blank_net_worths.join(", ")

    puts "------------------------------------------\n\n"

    puts "blank_projects size #{blank_projects.size}\n"
    puts blank_projects.join(", ")
  end
  
  # ==========================================

  desc "Task description"
  task :fundfenhong => [:dependent, :tasks] do
    sb = SpiderBase.new
    fundchaifen_dir = Rails.public_path.join("fund/eastmoney/fundchaifen_with_paginate")
    FileUtils::mkdir_p(fundchaifen_dir)

    1.upto(23).each_with_index do |page, index|
      url = "http://fund.eastmoney.com/Data/funddataIndex_Interface.aspx?dt=9&page=#{page}&rank=FSRQ&sort=desc&gs=&ftype=&year="


      fetch_content = sb.page_for_url(url);
      puts "Fetch data from #{url} =========== #{index}"


      doc = fetch_content.doc;

      file_name_with_path = fundchaifen_dir.join("#{page}.html")

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "============= Exception #{e}"
        break
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    # sb = SpiderBase.new
    fundchaifen_dir = Rails.public_path.join("fund/eastmoney/fundchaifen_with_paginate")

    blank_net_worths = []
    blank_projects = []

    1.upto(23).each_with_index do |page, index|
      puts "=== === === set page #{page} === === ==="
      file_name_with_path = fundchaifen_dir.join("#{page}.html")

      # fetch_content = sb.page_for_url(url);

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      result_text = doc.css("body").text.gsub(/^(var)|( var)|(var )|( var )/, "");

      pageinfo = eval(result_text.split(";")[0])

      # 基金代码  基金简称  拆分折算日 拆分类型  拆分折算(每份) 操作(是,否)
      jjcf_data = eval(result_text.split(";")[1])

      jjcf_jjgs = eval(result_text.split(";")[2])
      jjcf_year = eval(result_text.split(";")[3])
      jjcf_ftype = eval(result_text.split(";")[4])
        # eval(result_text)
      # end

      jjcf_data.each do |fund_chai_fen_data_array|
        code = fund_chai_fen_data_array[0]
        name = fund_chai_fen_data_array[1]

        break_convert_at = fund_chai_fen_data_array[2]
        break_type = fund_chai_fen_data_array[3]
        break_ratio = fund_chai_fen_data_array[4]
        # 略 = fund_chai_fen_data_array[5]

        project = Project.find_by(code: code)

        if project.present?
          net_worth = project.net_worths.find_by(record_at: break_convert_at.to_time)

          # ...
          if net_worth.present?
            net_worth_id = net_worth.id

            project.fund_chai_fens.create(
              net_worth_id: net_worth_id,
              break_convert_at: break_convert_at.to_time,
              break_type: break_type,
              break_ratio: break_ratio)
          else
            project.fund_chai_fens.create(
              break_convert_at: break_convert_at.to_time,
              break_type: break_type,
              break_ratio: break_ratio)
          end
        else
          blank_projects << "#{name}-#{code}"
        end
      end
    end

    # puts "------------------------------------------\n\n"

    # puts "blank_net_worths size #{blank_net_worths.size}\n"
    # puts blank_net_worths.join(", ")

    puts "------------------------------------------\n\n"

    puts "blank_projects size #{blank_projects.size}\n"
    puts blank_projects.join(", ")
  end
end
