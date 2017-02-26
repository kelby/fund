namespace :fund_toolbox do
  desc "Task description"
  task :set_up_from_yield_type_with_date_range => [:environment] do
    Project.joins(:net_worths).distinct.find_each do |project|
      begin
        project.set_up_from_yield_type_with_date_range
      rescue Exception => e
        next
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    Project.joins(:net_worths, :fund_fen_hongs, :fund_chai_fens).distinct.find_each do |project|
      begin
        project.set_up_from_yield_type_with_date_range
      rescue Exception => e
        next
      end
    end
  end
end
