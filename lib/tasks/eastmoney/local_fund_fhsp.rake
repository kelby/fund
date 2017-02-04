namespace :eastmoney do
  desc "Task description"
  task :local_fund_fhsp => [:environment] do


    fund_fhsp_dir = Rails.public_path.join("fund/eastmoney/fhsp")

    fen_hong_blank_net_worths = []
    chai_fen_blank_net_worths = []


    Dir.entries(fund_fhsp_dir).each_with_index do |file_name, index|
      unless file_name =~ /html/
        next
      end

      file_path = fund_fhsp_dir.join(file_name)

      doc = Nokogiri::HTML(open(file_path).read);

      code = file_name.split(".").first
      project = Project.find_by(code: code)

      if project.blank?
        next
      end

      # 分红送配详情
      cfxq_ele = doc.css("table.cfxq")

      # 拆分详情
      fhxq_ele = doc.css("table.fhxq")

      if cfxq_ele.blank? && fhxq_ele.blank?
        next
      end

      if cfxq_ele.text =~ /暂无分红信息/
        # ...
      else
        tr_eles = cfxq_ele.css("tbody > tr")

        #  register_at              :date
        #  ex_dividend_at           :date
        #  bonus_per                :string(255)
        #  dividend_distribution_at :date
        #  project_id               :integer
        #  net_worth_id             :integer
        tr_eles.each do |tr_ele|
          tds = tr_ele.css("td")

          # 年份
          # skip tds[0]

          # 权益登记日
          register_at_ele = tds[1]
          register_at = register_at_ele.text

          # 除息日
          ex_dividend_at_ele = tds[2]
          ex_dividend_at = ex_dividend_at_ele.text

          # 每份分红
          bonus_per_ele = tds[3]
          bonus_per = bonus_per_ele.text

          # 分红发放日
          dividend_distribution_at_ele = tds[4]
          dividend_distribution_at = dividend_distribution_at_ele.text

          net_worth = project.net_worths.where(record_at: ex_dividend_at).first

          if net_worth.present?
            net_worth.fund_fen_hongs.create(register_at: register_at,
              ex_dividend_at: ex_dividend_at,
              bonus_per: bonus_per,
              dividend_distribution_at: dividend_distribution_at,
              project_id: project.id)
          else
            fen_hong_blank_net_worths << "#{project.code}--#{project.name}"
          end
        end
      end


      if fhxq_ele.text =~ /暂无拆分信息/
        # ...
      else
        tr_eles = fhxq_ele.css("tbody > tr")

        #  break_convert_at :date
        #  break_type       :string(255)
        #  break_ratio      :string(255)
        #  project_id       :integer
        #  net_worth_id     :integer
        tr_eles.each do |tr_ele|
          tds = tr_ele.css("td")

          # 年份
          # skip tds[0]

          # 拆分折算日
          break_convert_at_ele = tds[1]
          break_convert_at = break_convert_at_ele.text

          # 拆分类型
          break_type_ele = tds[2]
          break_type = break_type_ele.text

          # 拆分折算比例
          break_ratio_ele = tds[3]
          break_ratio = break_ratio_ele.text


          net_worth = project.net_worths.where(record_at: break_convert_at).first

          if net_worth.present?
            net_worth.fund_chai_fens.create(break_convert_at: break_convert_at,
              break_type: break_type,
              break_ratio: break_ratio,
              project_id: project.id)
          else
            chai_fen_blank_net_worths << "#{project.code}--#{project.name}"
          end
        end
      end
    end

    puts "以下基金数据可能有问题\n#{fen_hong_blank_net_worths.join(', ')}\n#{chai_fen_blank_net_worths.join(', ')}"


  end
  
end