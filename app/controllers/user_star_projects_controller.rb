class UserStarProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_user_star_project, only: [:show, :edit, :update]

  # GET /user_star_projects
  def index
    @user_star_projects = UserStarProject.all
  end

  # GET /user_star_projects/1
  def show
  end

  # GET /user_star_projects/new
  def new
    @user_star_project = UserStarProject.new
  end

  # GET /user_star_projects/1/edit
  def edit
  end

  # POST /user_star_projects
  def create
    @project = Project.find(params[:project_id])
    @user = current_user

    # @user_star_project = UserStarProject.new(user_star_project_params)
    @user_star_project = UserStarProject.new(project_id: @project.id, user_id: @user.id)

    respond_to do |format|
      if @user_star_project.save
        # format.html { redirect_to @project, notice: 'User star project was successfully created.' }
        format.js
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /user_star_projects/1
  def update
    respond_to do |format|
      if @user_star_project.update(user_star_project_params)
        format.html { redirect_to @user_star_project, notice: 'User star project was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /user_star_projects/1
  def destroy
    @project = Project.find(params[:project_id])
    @user = current_user

    @user_star_projects = UserStarProject.where(project_id: @project.id, user_id: @user.id)
    @user_star_projects.destroy_all

    respond_to do |format|
      # format.html { redirect_to project_url(@project), notice: 'User star project was successfully destroyed.' }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_star_project
      @user_star_project = UserStarProject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_star_project_params
      params.require(:user_star_project).permit(:user_id, :project_id)
    end
end
