class Panel::ProjectsController < Panel::PanelController
  before_action :set_panel_project, only: [:show, :edit, :update, :destroy]

  def search
    @panel_projects = ::Project.all.order(id: :desc).includes(:category).page(params[:page])

    if params[:name].present?
      @panel_projects = @panel_projects.joins(:category).where("projects.name LIKE ? OR categories.name LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
    end

    if params[:status].present?
      @panel_projects = @panel_projects.where(status: params[:status])
    end

    if params[:identity].present?
      @panel_projects = @panel_projects.where(identity: params[:identity])
    end

    render :index
  end

  # GET /panel/projects
  def index
    @panel_projects = ::Project.all.includes(:category, :pod_info, :gem_info, :package_info).page(params[:page])
  end

  # GET /panel/projects/1
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
  def create
    @panel_project = ::Project.new(panel_project_params)

    respond_to do |format|
      if @panel_project.save
        format.html { redirect_to edit_panel_project_url(@panel_project), notice: 'Project was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /panel/projects/1
  def update
    respond_to do |format|
      if @panel_project.update(panel_project_params)
        format.html { redirect_to edit_panel_project_url(@panel_project), notice: 'Project was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /panel/projects/1
  def destroy
    @panel_project.destroy
    respond_to do |format|
      format.html { redirect_to panel_projects_url, notice: 'Project was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_project
      @panel_project = ::Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_project_params
      params.fetch(:project, {}).permit(:author, :name, :human_name, :identity,
        :status, :source_code, :description, :today_recommend, :given_name,
        :category_id)
    end
end
