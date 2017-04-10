class ArticleCategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :set_article_category, only: [:show, :edit, :update, :destroy]

  # GET /article_categories
  # GET /article_categories.json
  def index
    @article_categories = ArticleCategory.all
  end

  # GET /article_categories/1
  # GET /article_categories/1.json
  def show
  end

  # GET /article_categories/new
  def new
    @article_category = ArticleCategory.new
  end

  # GET /article_categories/1/edit
  def edit
  end

  # POST /article_categories
  # POST /article_categories.json
  def create
    @article_category = ArticleCategory.new(article_category_params)

    respond_to do |format|
      if @article_category.save
        format.html { redirect_to @article_category, notice: 'Article category was successfully created.' }
        format.json { render :show, status: :created, location: @article_category }
      else
        format.html { render :new }
        format.json { render json: @article_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_categories/1
  # PATCH/PUT /article_categories/1.json
  def update
    respond_to do |format|
      if @article_category.update(article_category_params)
        format.html { redirect_to @article_category, notice: 'Article category was successfully updated.' }
        format.json { render :show, status: :ok, location: @article_category }
      else
        format.html { render :edit }
        format.json { render json: @article_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_categories/1
  # DELETE /article_categories/1.json
  def destroy
    @article_category.destroy
    respond_to do |format|
      format.html { redirect_to article_categories_url, notice: 'Article category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_category
      @article_category = ArticleCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_category_params
      params.require(:article_category).permit(:name, :slug, :cover, :intro, :article_catalog_id)
    end
end
