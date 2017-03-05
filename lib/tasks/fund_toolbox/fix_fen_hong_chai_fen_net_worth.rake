namespace :eastmoney do
  desc "Task description"
  task :fix_fen_hong_chai_fen_net_worth => [:dependent, :tasks] do
    FundFenHong.where(net_worth_id: nil).find_each do |ffh|
      net_worth = ffh.project.net_worths.where("record_at >= ?", ffh.ex_dividend_at).asc.first

      if net_worth.present?
        ffh.net_worth_id = net_worth.id
        ffh.the_real_ex_dividend_at = net_worth.record_at

        if ffh.changed?
          ffh.save
        end
      end
    end

    FundFenHong.find_each do |ffh|
      net_worth = ffh.project.net_worths.where("record_at >= ?", ffh.ex_dividend_at).asc.first

      if net_worth.present?
        ffh.net_worth_id = net_worth.id
        ffh.the_real_ex_dividend_at = net_worth.record_at

        if ffh.changed?
          ffh.save
        end
      end
    end

    FundChaiFen.where(net_worth_id: nil).find_each do |fcf|
      net_worth = fcf.project.net_worths.where("record_at >= ?", fcf.break_convert_at).asc.first

      if net_worth.present?
        fcf.net_worth_id = net_worth.id
        fcf.the_real_break_convert_at = net_worth.record_at

        if fcf.changed?
          fcf.save
        end
      end
    end
  end
end
