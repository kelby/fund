class CatalogsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :edit, :destroy]
  before_action :set_catalog, only: [:show, :edit, :update, :destroy]

  # GET
  # def rails
  #   @catalogs = RailsCatalog.online.includes(:online_categories)

  #   @title = Catalog::TOP_PLURAL['gemspec']
  #   render :language
  # end

  # def swift
  #   @catalogs = SwiftCatalog.online.includes(:online_categories)

  #   @title = Catalog::TOP_PLURAL['pod']
  #   render :language
  # end

  # def laravel
  #   @catalogs = LaravelCatalog.online.includes(:online_categories)

  #   render :language
  # end

  # GET /catalogs
  def index
    # @rails_catalogs = RailsCatalog.online
    # @laravel_catalogs = LaravelCatalog.online
    # @swift_catalogs = SwiftCatalog.online

    @catalogs = Catalog.where(type: [nil, ''])
  end

  # GET /catalogs/1
  def show
    @projects = @catalog.projects.confirm_lineal

    @catalog_sina_info = @catalog.catalog_sina_info
    @catalog_eastmoney_info = @catalog.catalog_eastmoney_info
  end

  # GET /catalogs/new
  def new
    @catalog = Catalog.new
  end

  # GET /catalogs/1/edit
  def edit
  end

  # POST /catalogs
  def create
    @catalog = Catalog.new(catalog_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to catalog_path(@catalog), notice: 'Catalog was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /catalogs/1
  def update
    authorize! :update, @catalog

    respond_to do |format|
      if @catalog.update(catalog_params.merge(user_id: current_user.id))
        format.html { redirect_to catalog_path(@catalog), notice: 'Catalog was successfully updated.' }
        # format.html { redirect_to catalogs_path, notice: 'Catalog was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /catalogs/1
  def destroy
    authorize! :destroy, @catalog

    @catalog.destroy
    respond_to do |format|
      format.html { redirect_to catalogs_url, notice: 'Catalog was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:name, :slug, :type, :code, :short_name)
    end
end
