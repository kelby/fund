json.extract! user_star_project, :id, :user_id, :project_id, :created_at, :updated_at
json.url user_star_project_url(user_star_project, format: :json)