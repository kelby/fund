namespace :sohu do
  desc "Task description"
  task :create_fund_ranking => [:environment] do
    fund_ranking_dir = Rails.public_path.join("fund/sohu/fund_ranking")
    fund_type = ""
    evaluate_type = ""

    # table_type = "two_one"
    # table_type = "three_five"

    had_record = []
    problem_record = []

    Dir.entries(fund_ranking_dir).each_with_index do |file_name, index|
      unless file_name =~ /\d+/
        next
      end

      file_path = fund_ranking_dir.join(file_name)
      record_at = file_name.split(".").first

      puts "set fund ranking date #{record_at} ================ #{index}"

      had_record << record_at

      doc = Nokogiri::HTML(open(file_path).read);

      if doc.css("table").blank?
        next
      end

      ranking_table_ele = doc.css("table")[2]

      if ranking_table_ele.css("tr").blank?
        next
      end

      ranking_table_ele.css("tr").each do |tr_ele|
        tr_text = tr_ele.text

        if tr_text =~ /基金代码/ && tr_text =~ /基金名称/
          if tr_text =~ /最近一年风险评价/
            evaluate_type = "two_one"
          elsif tr_text =~ /最近三年风险评价/
            evaluate_type = "three_five"
          else
            # evaluate_type = ""
          end

          next
        end

        if tr_text =~ /排名/ && tr_text =~ /总回报率/
          next
        end

        if tr_ele.css("td").blank?
          next
        end

        if tr_ele.css("td").size == 1
          fund_type = tr_ele.css("td").text
          next
        end

        # 0, 1 - 基金代码  基金名称
        code = tr_ele.css("td")[0].text.try(:strip)
        name = tr_ele.css("td")[1].text.try(:strip)

        if tr_ele.css("td").size < 26
          problem_record << "#{record_at}--#{code}--#{name}"
          puts "tr_ele has problem, it's #{tr_ele}"
          next
        end

        # 2 - 单位净值
        if tr_ele.css("td")[2].present?
          dwjz = tr_ele.css("td")[2].text
        else
          dwjz = nil
        end

        # 3, 4 - 晨星评级
        ranking_first_ele = tr_ele.css("td")[3]
        ranking_second_ele = tr_ele.css("td")[4]

        if evaluate_type == "two_one"
          two_year_rating = ranking_first_ele.text.size if ranking_first_ele.text.present? && ranking_first_ele.text =~ /★/
          one_year_rating = ranking_second_ele.text.size if ranking_second_ele.text.present? && ranking_second_ele.text =~ /★/
        elsif evaluate_type == "three_five"
          three_year_rating = ranking_first_ele.text.size if ranking_first_ele.text.present? && ranking_first_ele.text =~ /★/
          five_year_rating = ranking_second_ele.text.size if ranking_second_ele.text.present? && ranking_second_ele.text =~ /★/
        else
          two_year_rating = nil
          one_year_rating = nil
          three_year_rating = nil
          five_year_rating = nil
        end

        # 5, 6 - 最近一周
        last_week_total_return = tr_ele.css("td")[5].text
        last_week_ranking = tr_ele.css("td")[6].text

        # 7, 8 - 最近一月
        last_month_total_return = tr_ele.css("td")[7].text
        last_month_ranking = tr_ele.css("td")[8].text

        # 9, 10 - 最近三月
        last_three_month_total_return = tr_ele.css("td")[9].text
        last_three_month_ranking = tr_ele.css("td")[10].text

        # 11, 12 - 最近六月
        last_six_month_total_return = tr_ele.css("td")[11].text
        last_six_month_ranking = tr_ele.css("td")[12].text

        # 13, 14 - 最近一年
        last_year_total_return = tr_ele.css("td")[13].text
        last_year_ranking = tr_ele.css("td")[14].text

        # 15, 16 - 最近两年
        last_two_year_total_return = tr_ele.css("td")[15].text
        last_two_year_ranking = tr_ele.css("td")[16].text

        # 17, 18 - 今年以来
        this_year_total_return = tr_ele.css("td")[17].text
        this_year_ranking = tr_ele.css("td")[18].text

        # 19 - 设立以来
        since_the_inception_total_return = tr_ele.css("td")[19].text

        # 20, 21, 22, 23 - 最近一/三年风险评价
        if evaluate_type == "two_one"
          last_one_year_volatility = tr_ele.css("td")[20].text
          last_one_year_volatility_evaluate = tr_ele.css("td")[21].text
          last_one_year_risk_factor = tr_ele.css("td")[22].text
          last_one_year_risk_factor_evaluate = tr_ele.css("td")[23].text
        elsif evaluate_type == "three_five"
          last_three_year_volatility = tr_ele.css("td")[20].text
          last_three_year_volatility_evaluate = tr_ele.css("td")[21].text
          last_three_year_risk_factor = tr_ele.css("td")[22].text
          last_three_year_risk_factor_evaluate = tr_ele.css("td")[23].text
        else
          last_one_year_volatility = nil
          last_one_year_volatility_evaluate = nil
          last_one_year_risk_factor = nil
          last_one_year_risk_factor_evaluate = nil
          last_three_year_volatility = nil
          last_three_year_volatility_evaluate = nil
          last_three_year_risk_factor = nil
          last_three_year_risk_factor_evaluate = nil
        end

        # 24, 25 - 夏普比率
        if evaluate_type == "two_one"
          last_one_year_sharpe_ratio = tr_ele.css("td")[24].text
          last_one_year_sharpe_ratio_evaluate = tr_ele.css("td")[25].text
        elsif evaluate_type == "three_five"
          last_three_year_sharpe_ratio = tr_ele.css("td")[24].text
          last_three_year_sharpe_ratio_evaluate = tr_ele.css("td")[25].text
        else
          last_one_year_sharpe_ratio = nil
          last_one_year_sharpe_ratio_evaluate = nil
          last_three_year_sharpe_ratio = nil
          last_three_year_sharpe_ratio_evaluate = nil
        end

        FundRanking.create(record_at: record_at,
          fund_type: fund_type,
          evaluate_type: evaluate_type,
          code: code,
          name: name,
          dwjz: dwjz,
          two_year_rating: two_year_rating,
          one_year_rating: one_year_rating,
          three_year_rating: three_year_rating,
          five_year_rating: five_year_rating,
          last_week_total_return: last_week_total_return,
          last_week_ranking: last_week_ranking,
          last_month_total_return: last_month_total_return,
          last_month_ranking: last_month_ranking,
          last_three_month_total_return: last_three_month_total_return,
          last_three_month_ranking: last_three_month_ranking,
          last_six_month_total_return: last_six_month_total_return,
          last_six_month_ranking: last_six_month_ranking,
          last_year_total_return: last_year_total_return,
          last_year_ranking: last_year_ranking,
          last_two_year_total_return: last_two_year_total_return,
          last_two_year_ranking: last_two_year_ranking,
          this_year_total_return: this_year_total_return,
          this_year_ranking: this_year_ranking,
          since_the_inception_total_return: since_the_inception_total_return,
          last_one_year_volatility: last_one_year_volatility,
          last_one_year_volatility_evaluate: last_one_year_volatility_evaluate,
          last_one_year_risk_factor: last_one_year_risk_factor,
          last_one_year_risk_factor_evaluate: last_one_year_risk_factor_evaluate,
          last_three_year_volatility: last_three_year_volatility,
          last_three_year_volatility_evaluate: last_three_year_volatility_evaluate,
          last_three_year_risk_factor: last_three_year_risk_factor,
          last_three_year_risk_factor_evaluate: last_three_year_risk_factor_evaluate,
          last_one_year_sharpe_ratio: last_one_year_sharpe_ratio,
          last_one_year_sharpe_ratio_evaluate: last_one_year_sharpe_ratio_evaluate,
          last_three_year_sharpe_ratio: last_three_year_sharpe_ratio,
          last_three_year_sharpe_ratio_evaluate: last_three_year_sharpe_ratio_evaluate);
      end

      evaluate_type = ""      
    end

    puts "had_record #{had_record.size} \n"
    puts had_record.join(', ')
    puts "-----------------------------\n"
    puts "problem_record #{problem_record.size} \n"
    puts problem_record.join(', ')

  end  
end
