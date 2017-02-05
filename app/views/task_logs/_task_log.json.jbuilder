json.extract! task_log, :id, :code, :level, :content, :ext_info, :created_at, :updated_at
json.url task_log_url(task_log, format: :json)