class UserRecommendProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_user_recommend_project, only: [:show, :edit, :update]

  # GET /user_recommend_projects
  def index
    @user_recommend_projects = UserRecommendProject.all
  end

  # GET /user_recommend_projects/1
  def show
  end

  # GET /user_recommend_projects/new
  def new
    @user_recommend_project = UserRecommendProject.new
  end

  # GET /user_recommend_projects/1/edit
  def edit
  end

  # POST /user_recommend_projects
  def create
    @project = Project.find(params[:project_id])
    @user = current_user

    # @user_recommend_project = UserRecommendProject.new(user_recommend_project_params)
    @user_recommend_project = UserRecommendProject.new(project_id: @project.id, user_id: @user.id)

    respond_to do |format|
      if @user_recommend_project.save
        # format.html { redirect_to @project, notice: 'User recommend project was successfully created.' }
        format.js
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /user_recommend_projects/1
  def update
    respond_to do |format|
      if @user_recommend_project.update(user_recommend_project_params)
        format.html { redirect_to @user_recommend_project, notice: 'User recommend project was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /user_recommend_projects/1
  def destroy
    @project = Project.find(params[:project_id])
    @user = current_user

    @user_recommend_projects = UserRecommendProject.where(project_id: @project.id, user_id: @user.id)
    @user_recommend_projects.destroy_all

    respond_to do |format|
      # format.html { redirect_to @project, notice: 'User recommend project was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_recommend_project
      @user_recommend_project = UserRecommendProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_recommend_project_params
      params.require(:user_recommend_project).permit(:user_id, :project_id)
    end
end
