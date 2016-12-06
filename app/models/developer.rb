class Developer < ApplicationRecord
  has_many :projects

  def self.create_developer_from_projects
    Project.find_each do |project|
      developer = Developer.find_or_create_by(name: project.author)

      project.update_columns(developer_id: developer.id)
    end
  end
end
