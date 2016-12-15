class Panel::CategoriesController < ApplicationController
  before_action :set_panel_category, only: [:show, :edit, :update, :destroy]

  # GET /panel/categories
  # GET /panel/categories.json
  def index
    @panel_categories = ::Category.all.order(id: :desc).includes(:catalog).page(params[:page])
  end

  # GET /panel/categories/1
  # GET /panel/categories/1.json
  def show
    @projects = @panel_category.projects.page(params[:page])
  end

  # GET /panel/categories/new
  def new
    @panel_category = ::Category.new
  end

  # GET /panel/categories/1/edit
  def edit
  end

  # POST /panel/categories
  # POST /panel/categories.json
  def create
    @panel_category = ::Category.new(panel_category_params)

    respond_to do |format|
      if @panel_category.save
        format.html { redirect_to @panel_category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @panel_category }
      else
        format.html { render :new }
        format.json { render json: @panel_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panel/categories/1
  # PATCH/PUT /panel/categories/1.json
  def update
    respond_to do |format|
      if @panel_category.update(panel_category_params)
        format.html { redirect_to @panel_category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @panel_category }
      else
        format.html { render :edit }
        format.json { render json: @panel_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panel/categories/1
  # DELETE /panel/categories/1.json
  def destroy
    @panel_category.destroy
    respond_to do |format|
      format.html { redirect_to panel_categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_category
      @panel_category = ::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_category_params
      params.fetch(:panel_category, {})
    end
end
