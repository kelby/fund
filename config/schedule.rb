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

every 1.hours do
  runner "Category.nil_catalog_so_offline"
  runner "Category.no_online_projects_so_offline"
  runner "Catalog.no_online_categories_so_offline"
end

every 2.hours do
  runner "Project.set_all_github_info"
  runner "Project.set_info"

  runner "Developer.create_developer_from_projects"
end

every 3.hours do
  runner "Project.detect_and_set_online"

  runner "GithubInfo.set_project_nightspot"
end
