class Panel::ProjectsController < ApplicationController
  before_action :set_panel_project, only: [:show, :edit, :update, :destroy]

  # GET /panel/projects
  # GET /panel/projects.json
  def index
    @panel_projects = ::Project.all.includes(:category).page(params[:page])
  end

  # GET /panel/projects/1
  # GET /panel/projects/1.json
  def show
  end

  # GET /panel/projects/new
  def new
    @panel_project = ::Project.new
  end

  # GET /panel/projects/1/edit
  def edit
  end

  # POST /panel/projects
  # POST /panel/projects.json
  def create
    @panel_project = ::Project.new(panel_project_params)

    respond_to do |format|
      if @panel_project.save
        format.html { redirect_to @panel_project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @panel_project }
      else
        format.html { render :new }
        format.json { render json: @panel_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panel/projects/1
  # PATCH/PUT /panel/projects/1.json
  def update
    respond_to do |format|
      if @panel_project.update(panel_project_params)
        format.html { redirect_to @panel_project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @panel_project }
      else
        format.html { render :edit }
        format.json { render json: @panel_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panel/projects/1
  # DELETE /panel/projects/1.json
  def destroy
    @panel_project.destroy
    respond_to do |format|
      format.html { redirect_to panel_projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_project
      @panel_project = ::Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_project_params
      params.fetch(:panel_project, {})
    end
end
