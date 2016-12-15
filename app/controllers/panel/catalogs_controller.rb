class Panel::CatalogsController < ApplicationController
  before_action :set_panel_catalog, only: [:show, :edit, :update, :destroy]


  def search
    @panel_catalogs = ::Catalog.all.order(id: :desc).page(params[:page])

    if params[:top_catalog].present?
      @panel_catalogs = @panel_catalogs.where(type: params[:top_catalog])
    end

    if params[:name].present?
      @panel_catalogs = @panel_catalogs.where("name LIKE ?", "%#{params[:name]}%")
    end

    if params[:status].present?
      @panel_catalogs = @panel_catalogs.where(status: params[:status])
    end

    if params[:categories_count].present?
      @panel_catalogs = @panel_catalogs.where(categories_count: params[:categories_count])
    end

    render :index
  end

  # GET /panel/catalogs
  def index
    @panel_catalogs = ::Catalog.all.order(id: :desc).page(params[:page])
  end

  # GET /panel/catalogs/1
  def show
  end

  # GET /panel/catalogs/new
  def new
    @panel_catalog = ::Catalog.new
  end

  # GET /panel/catalogs/1/edit
  def edit
  end

  # POST /panel/catalogs
  def create
    @panel_catalog = ::Catalog.new(panel_catalog_params)

    respond_to do |format|
      if @panel_catalog.save
        format.html { redirect_to @panel_catalog, notice: 'Catalog was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /panel/catalogs/1
  def update
    respond_to do |format|
      if @panel_catalog.update(panel_catalog_params)
        format.html { redirect_to edit_panel_catalog_url(@panel_catalog), notice: 'Catalog was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /panel/catalogs/1
  def destroy
    @panel_catalog.destroy
    respond_to do |format|
      format.html { redirect_to panel_catalogs_url, notice: 'Catalog was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_catalog
      @panel_catalog = ::Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_catalog_params
      params.fetch(:catalog, {}).permit(:name, :slug, :type, :sketch)
    end
end
