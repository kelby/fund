class IndexReportsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_index_report, only: [:show, :edit, :update, :destroy]

  def catalog
    @catalog = IndexCatalog.find_by(slug: params[:catalog_slug])

    @index_reports = @catalog.index_reports.page(params[:page]).per(50)

    @title = @catalog.name
    render :index
  end

  def category
    @catalog = IndexCatalog.find_by(slug: params[:catalog_slug])
    _category = @catalog.index_categories.find_by(slug: params[:category_slug])

    @index_reports = _category.index_reports.page(params[:page]).per(50)

    @title = _category.name
    @description = _category.intro

    render :index
  end

  # GET /index_reports
  # GET /index_reports.json
  def index
    @index_reports = IndexReport.all.page(params[:page]).per(50)

    @title = "指数系列"
  end

  # GET /index_reports/1
  # GET /index_reports/1.json
  def show
  end

  # GET /index_reports/new
  def new
    @index_report = IndexReport.new
  end

  # GET /index_reports/1/edit
  def edit
  end

  # POST /index_reports
  # POST /index_reports.json
  def create
    @index_report = IndexReport.new(index_report_params)

    respond_to do |format|
      if @index_report.save
        format.html { redirect_to @index_report, notice: 'Index report was successfully created.' }
        format.json { render :show, status: :created, location: @index_report }
      else
        format.html { render :new }
        format.json { render json: @index_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /index_reports/1
  # PATCH/PUT /index_reports/1.json
  def update
    authorize! :update, @index_report

    respond_to do |format|
      if @index_report.update(index_report_params)
        format.html { redirect_to @index_report, notice: 'Index report was successfully updated.' }
        format.json { render :show, status: :ok, location: @index_report }
      else
        format.html { render :edit }
        format.json { render json: @index_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /index_reports/1
  # DELETE /index_reports/1.json
  def destroy
    authorize! :destroy, @index_report

    @index_report.destroy
    respond_to do |format|
      format.html { redirect_to index_reports_url, notice: 'Index report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index_report
      get_code = params[:id].split("-").first

      @index_report = IndexReport.find_by(code: get_code)

      if @index_report.blank?
        @index_report = IndexReport.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def index_report_params
      params.require(:index_report).permit(:catalog, :category, :category_intro, :name, :intro, :website, :code, :set_up_at)
    end
end
