class ProjectSearchController < ApplicationController
  def index
    projects = Project.all

    if params[:type].present?
      projects = projects.where(identity: params[:type])
    end

    @projects = projects.where("name LIKE ?", "%#{params[:q]}%")
  end
end
