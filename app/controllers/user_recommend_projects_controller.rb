class UserRecommendProjectsController < ApplicationController
  before_action :set_user_recommend_project, only: [:show, :edit, :update, :destroy]

  # GET /user_recommend_projects
  # GET /user_recommend_projects.json
  def index
    @user_recommend_projects = UserRecommendProject.all
  end

  # GET /user_recommend_projects/1
  # GET /user_recommend_projects/1.json
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
  # POST /user_recommend_projects.json
  def create
    @project = Project.find(params[:project_id])
    @user = current_user

    # @user_recommend_project = UserRecommendProject.new(user_recommend_project_params)
    @user_recommend_project = UserRecommendProject.new(project_id: @project.id, user_id: @user.id)

    respond_to do |format|
      if @user_recommend_project.save
        format.html { redirect_to @project, notice: 'User recommend project was successfully created.' }
        format.json { render :show, status: :created, location: @user_recommend_project }
      else
        format.html { render :new }
        format.json { render json: @user_recommend_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_recommend_projects/1
  # PATCH/PUT /user_recommend_projects/1.json
  def update
    respond_to do |format|
      if @user_recommend_project.update(user_recommend_project_params)
        format.html { redirect_to @user_recommend_project, notice: 'User recommend project was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_recommend_project }
      else
        format.html { render :edit }
        format.json { render json: @user_recommend_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_recommend_projects/1
  # DELETE /user_recommend_projects/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @user = current_user

    @user_recommend_projects = UserRecommendProject.where(project_id: @project.id, user_id: @user.id)
    @user_recommend_projects.destroy_all

    respond_to do |format|
      format.html { redirect_to @project, notice: 'User recommend project was successfully destroyed.' }
      format.json { head :no_content }
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
