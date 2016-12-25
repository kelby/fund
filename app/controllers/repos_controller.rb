class ReposController < ApplicationController
  before_action :set_project, only: [:popularity, :star, :recommend]

  def star
    @users = @project.star_by_users
  end

  def recommend
    @users = @project.recommend_by_users
  end

  def popularity
  end

  private
  def set_project
    @project = Project.where(author: params[:author], name: params[:name]).first

    if @project.blank? && params[:id].present?
      @project = Project.find(params[:id])
    end
  end
end
