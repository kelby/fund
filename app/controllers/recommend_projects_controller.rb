class RecommendProjectsController < ApplicationController
  before_action :get_data, only: [:add, :remove]

  def new
    @project = Project.find(params[:project_id])
    @episodes = Episode.all.order(id: :desc)

    respond_to do |format|
      format.js
    end
  end

  def create
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.js
    end
  end

  def add
    project_list_array = @episode.project_list_array + [@project.id.to_s]
    @episode.project_list = project_list_array.join(",")

    @episode.save

    respond_to do |format|
      format.js {head :ok}
    end
  end

  def remove
    project_list_array = @episode.project_list_array - [@project.id.to_s]
    @episode.project_list = project_list_array.join(",")

    @episode.save

    respond_to do |format|
      format.js {head :ok}
    end
  end

  private
  def get_data
    @project = Project.find(params[:project_id])
    @episode = Episode.find(params[:episode_id])
  end
end
