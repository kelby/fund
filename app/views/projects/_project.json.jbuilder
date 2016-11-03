json.extract! project, :id, :name, :description, :website, :wiki, :source_code, :package_id, :created_at, :updated_at
json.url project_url(project, format: :json)