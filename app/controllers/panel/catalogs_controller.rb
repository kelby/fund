class Panel::CatalogsController < ApplicationController
  before_action :set_panel_catalog, only: [:show, :edit, :update, :destroy]

  # GET /panel/catalogs
  # GET /panel/catalogs.json
  def index
    @panel_catalogs = ::Catalog.all.order(id: :desc).page(params[:page])
  end

  # GET /panel/catalogs/1
  # GET /panel/catalogs/1.json
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
  # POST /panel/catalogs.json
  def create
    @panel_catalog = ::Catalog.new(panel_catalog_params)

    respond_to do |format|
      if @panel_catalog.save
        format.html { redirect_to @panel_catalog, notice: 'Catalog was successfully created.' }
        format.json { render :show, status: :created, location: @panel_catalog }
      else
        format.html { render :new }
        format.json { render json: @panel_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panel/catalogs/1
  # PATCH/PUT /panel/catalogs/1.json
  def update
    respond_to do |format|
      if @panel_catalog.update(panel_catalog_params)
        format.html { redirect_to @panel_catalog, notice: 'Catalog was successfully updated.' }
        format.json { render :show, status: :ok, location: @panel_catalog }
      else
        format.html { render :edit }
        format.json { render json: @panel_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panel/catalogs/1
  # DELETE /panel/catalogs/1.json
  def destroy
    @panel_catalog.destroy
    respond_to do |format|
      format.html { redirect_to panel_catalogs_url, notice: 'Catalog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_catalog
      @panel_catalog = ::Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_catalog_params
      params.fetch(:panel_catalog, {}).permit(:name, :type, :sketch)
    end
end
