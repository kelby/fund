class ProjectSearchController < ApplicationController
  def index
    projects = Project.show_status

    if params[:type].present?
      projects = projects.where(identity: params[:type])
    end

    @projects = projects.where("name LIKE ?", "%#{params[:q]}%").page(params[:page]).per(20)
  end
end
