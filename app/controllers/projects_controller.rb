class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :popularity]

  def search
    projects = Project.all

    if params[:type].present?
      projects = projects.where(identity: params[:type])
    end

    @projects = projects.where("name LIKE ?", "%#{params[:q]}%")
  end

  def popularity
  end

  # GET /projects
  def index
    @projects = Project.all.includes(:category, :github_info)
  end

  # GET /projects/1
  def show
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
end
