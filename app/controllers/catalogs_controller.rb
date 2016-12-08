class CatalogsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :edit, :destroy]
  before_action :set_catalog, only: [:show, :edit, :update, :destroy]

  # GET
  def rails
    @catalogs = RailsCatalog.all.includes(:categories)

    render :language
  end

  def swift
    @catalogs = SwiftCatalog.all.includes(:categories)

    render :language
  end

  def laravel
    @catalogs = LaravelCatalog.all.includes(:categories)

    render :language
  end

  # GET /catalogs
  def index
    @rails_catalogs = RailsCatalog.all
    @laravel_catalogs = LaravelCatalog.all
    @swift_catalogs = SwiftCatalog.all
  end

  # GET /catalogs/1
  def show
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
      params.require(:catalog).permit(:name, :slug, :type)
    end
end
