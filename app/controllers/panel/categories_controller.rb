class Panel::CategoriesController < Panel::PanelController
  before_action :set_panel_category, only: [:show, :edit, :update, :destroy, :create_projects]

  def create_projects
    if params[:projects_source_code].blank?
      return false
    end

    projects_source_code = params[:projects_source_code].split(/\r\n|\s/).delete_if{|x| x.blank? || !(x =~ /github\.com/)}

    catalog = @panel_category.catalog
    if catalog.present?
      identity = catalog.project_identity
    end

    projects_source_code.each do |link|
      delay = rand(1..60)
      Project.delay_for(delay).get_and_create_gem_project_from_option({'source_code' => link, 'identity' => identity, category_id: @panel_category.id})
    end

    redirect_to panel_category_url(@panel_category), notice: '正在抓取项目到此类目，请稍等。'
  end

  def search
    @panel_categories = ::Category.all.order(id: :desc).includes(:catalog).page(params[:page])

    if params[:top_catalog].present?
      @panel_categories = @panel_categories.joins(:catalog).where(catalogs: {type: params[:top_catalog]})
    end

    if params[:name].present?
      @panel_categories = @panel_categories.joins(:catalog).where("catalogs.name LIKE ? OR categories.name LIKE ?", "%#{params[:name]}%", "%#{params[:name]}%")
    end

    if params[:status].present?
      @panel_categories = @panel_categories.where(status: params[:status])
    end

    if params[:projects_count].present?
      @panel_categories = @panel_categories.where(projects_count: params[:projects_count])
    end

    render :index
  end

  # GET /panel/categories
  def index
    @panel_categories = ::Category.all.order(id: :desc).includes(:catalog).page(params[:page])
  end

  # GET /panel/categories/1
  def show
    @projects = @panel_category.projects.order(popularity: :desc).page(params[:page])
  end

  # GET /panel/categories/new
  def new
    @panel_category = ::Category.new
  end

  # GET /panel/categories/1/edit
  def edit
  end

  # POST /panel/categories
  def create
    @panel_category = ::Category.new(panel_category_params)
    respond_to do |format|
      if @panel_category.save
        format.html { redirect_to @panel_category, notice: 'Category was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /panel/categories/1
  def update
    respond_to do |format|
      if @panel_category.update(panel_category_params)
        format.html { redirect_to edit_panel_category_url(@panel_category), notice: 'Category was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /panel/categories/1
  def destroy
    @panel_category.destroy
    respond_to do |format|
      format.html { redirect_to panel_categories_url, notice: 'Category was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_category
      @panel_category = ::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_category_params
      params.fetch(:category, {}).permit(:name, :status, :slug, :catalog_id)
    end
end
