class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :edit, :destroy]

  before_action :set_project, only: [:show, :edit, :update, :destroy,
    :popularity, :star, :recommend]

  after_action :inc_view_times, only: [:show, :repo]

  def star
    @users = @project.star_by_users
  end

  def recommend
    @users = @project.recommend_by_users
  end

  def popularity
  end

  # GET /projects
  def index
    @projects = Project.online.includes(:category, :github_info).page(params[:page]).per(30)
  end

  # GET /projects/1
  def show
    get_relate_data
  end

  def repo
    @project = Project.where(author: params[:author], name: params[:name]).first

    get_relate_data

    render :show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_create_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /projects/1
  def update
    authorize :update, @project

    respond_to do |format|
      if @project.update(project_update_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /projects/1
  def destroy
    authorize :destroy, @project

    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_create_params
      params.require(:project).permit(:name, :description, :website, :wiki, :source_code,
        :category_id, :identity)
    end

    def project_update_params
      params.require(:project).permit(:name, :description, :website, :wiki, :source_code,
        :category_id)
    end

    def get_relate_data
      @comment = Comment.new
      @comments = @project.comments

      if @project.category.present?
        @projects = @project.category.projects.online.order(popularity: :desc).limit(6)
      end
    end

    def inc_view_times
      @project.increment!(:view_times)
    end
end
