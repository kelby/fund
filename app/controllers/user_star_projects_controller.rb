class UserStarProjectsController < ApplicationController
  before_action :set_user_star_project, only: [:show, :edit, :update, :destroy]

  # GET /user_star_projects
  # GET /user_star_projects.json
  def index
    @user_star_projects = UserStarProject.all
  end

  # GET /user_star_projects/1
  # GET /user_star_projects/1.json
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
  # POST /user_star_projects.json
  def create
    @project = Project.find(params[:project_id])
    @user = current_user

    # @user_star_project = UserStarProject.new(user_star_project_params)
    @user_star_project = UserStarProject.new(project_id: @project.id, user_id: @user.id)

    respond_to do |format|
      if @user_star_project.save
        format.html { redirect_to @project, notice: 'User star project was successfully created.' }
        format.json { render :show, status: :created, location: @user_star_project }
      else
        format.html { render :new }
        format.json { render json: @user_star_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_star_projects/1
  # PATCH/PUT /user_star_projects/1.json
  def update
    respond_to do |format|
      if @user_star_project.update(user_star_project_params)
        format.html { redirect_to @user_star_project, notice: 'User star project was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_star_project }
      else
        format.html { render :edit }
        format.json { render json: @user_star_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_star_projects/1
  # DELETE /user_star_projects/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @user = current_user

    @user_star_projects = UserStarProject.where(project_id: @project.id, user_id: @user.id)
    @user_star_projects.destroy_all

    respond_to do |format|
      format.html { redirect_to @project, notice: 'User star project was successfully destroyed.' }
      format.json { head :no_content }
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
