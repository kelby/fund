namespace :manager do
  desc "developer has projects, but no catalogs."
  task :set_catalog_from_projects => [:environment] do
    Developer.includes(:catalogs, :projects).find_each do |developer|
      if developer.catalogs.blank? && developer.projects.present?
        developer.projects.pluck(:catalog_id).each do |catalog_id|
          CatalogDeveloper.create(catalog_id: catalog_id, developer_id: developer.id)
        end
      end
    end
  end

  # desc "developer has catalogs, but no projects."
  # task :task_name => [:dependent, :tasks] do
  #   Developer.find_each do |developer|
  #     if developer.catalogs.present? && developer.projects.blank?
  #       # ...
  #     end
  #   end
  # end
end