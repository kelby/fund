json.extract! user_recommend_project, :id, :user_id, :project_id, :created_at, :updated_at
json.url user_recommend_project_url(user_recommend_project, format: :json)