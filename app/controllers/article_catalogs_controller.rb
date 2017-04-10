class ArticleCatalogsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :set_article_catalog, only: [:show, :edit, :update, :destroy]

  # GET /article_catalogs
  # GET /article_catalogs.json
  def index
    @article_catalogs = ArticleCatalog.all
  end

  # GET /article_catalogs/1
  # GET /article_catalogs/1.json
  def show
  end

  # GET /article_catalogs/new
  def new
    @article_catalog = ArticleCatalog.new
  end

  # GET /article_catalogs/1/edit
  def edit
  end

  # POST /article_catalogs
  # POST /article_catalogs.json
  def create
    @article_catalog = ArticleCatalog.new(article_catalog_params)

    respond_to do |format|
      if @article_catalog.save
        format.html { redirect_to @article_catalog, notice: 'Article catalog was successfully created.' }
        format.json { render :show, status: :created, location: @article_catalog }
      else
        format.html { render :new }
        format.json { render json: @article_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_catalogs/1
  # PATCH/PUT /article_catalogs/1.json
  def update
    respond_to do |format|
      if @article_catalog.update(article_catalog_params)
        format.html { redirect_to @article_catalog, notice: 'Article catalog was successfully updated.' }
        format.json { render :show, status: :ok, location: @article_catalog }
      else
        format.html { render :edit }
        format.json { render json: @article_catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_catalogs/1
  # DELETE /article_catalogs/1.json
  def destroy
    @article_catalog.destroy
    respond_to do |format|
      format.html { redirect_to article_catalogs_url, notice: 'Article catalog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_catalog
      @article_catalog = ArticleCatalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_catalog_params
      params.require(:article_catalog).permit(:name, :slug)
    end
end
