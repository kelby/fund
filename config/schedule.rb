# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 30.minutes, :roles => [:app] do
  # rake "fetch_manager_info_for_current_catalog"
  # rake "jzzs"
  # rake "fetch_eastmoney_fund_jbgk"
end


every 1.day, :at => '7:59 am' do
  rake "fetch_fundranking:set_all_fund_day_net_worth"
end

every 1.day, :at => '13:59 am' do
  rake "fetch_fundranking:set_all_fund_day_net_worth"
end

every 1.day, :at => '8:13 am' do
  rake "fund_toolbox:set_up_from_yield_type_with_date_range"
end

every 1.day, :at => '13:13 am' do
  rake "fund_toolbox:set_up_from_yield_type_with_date_range"
end

every 1.day, :at => '19:30 pm' do
  rake "eastmoney:touch_top_at_from_month_fundranking"
end

=begin
every 1.hours do
  runner "Project.delay_set_popularity"
  runner "Category.detect_and_set_online"

  runner "Category.nil_catalog_so_offline"

  runner "Category.no_online_projects_so_offline"

  runner "Catalog.has_online_categories_so_online"
  runner "Catalog.no_online_categories_so_offline"
end

every 2.hours do
  runner "Project.set_all_github_info"
  runner "Project.set_info"

  runner "Developer.create_developer_from_projects"
end

every 3.hours do
  runner "Project.pending_detect_and_set_online"

  runner "GithubInfo.set_online_project_nightspot"
end
=end

# every 12.hours do
  # runner "Project.batch_set_offline_gems_given_name"
# end
