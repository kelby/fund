namespace :fund_toolbox do
  desc "Task description"
  task :set_up_from_yield_type_with_date_range => [:environment] do
    Project.joins(:net_worths).distinct.find_each.with_index do |project, index|
      begin
        project.set_up_from_yield_type_with_date_range
      rescue Exception => e
        puts "project #{project.code}, index #{index}, #{e} ===================="
        # next
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    Project.joins(:net_worths, :fund_fen_hongs, :fund_chai_fens).distinct.find_each.with_index do |project, index|
      begin
        project.set_up_from_yield_type_with_date_range
      rescue Exception => e
        next
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    end_date = Time.now
    begin_date = 50.years.ago

    result_array = []

    Project.joins(:net_worths).distinct.find_each do |project|
      begin
        api_get_fund_yield = project.api_get_fund_yield_from_to(begin_date, end_date)
        result_array << "#{project.code}==#{api_get_fund_yield}"
      rescue Exception => e
        next
      end
    end

    result_array.join(", ")
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    FundFenHong.where(the_real_ex_dividend_at: nil).map &:set_the_real_ex_dividend_at
    FundFenHong.where(the_real_ex_dividend_at: nil).find_each do |fund_fen_hong|
      fund_fen_hong.the_real_ex_dividend_at = fund_fen_hong.ex_dividend_at
      fund_fen_hong.save
    end
  end
end
