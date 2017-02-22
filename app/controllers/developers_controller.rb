class DevelopersController < ApplicationController
  before_action :set_developer, only: [:edit, :update, :destroy, :show]

  # GET /developers
  def index
    @developers = Developer.online.includes(:catalogs).page(params[:page]).per(50)
  end

  # GET /developers/1
  def show
    @developer_projects = @developer.developer_projects.includes(:project).page(params[:page])
    @online_developer_projects = @developer.developer_projects.where(end_of_work_date: [nil, ""]).includes(:project)
  end

  # GET /developers/new
  def new
    @developer = Developer.new
  end

  # GET /developers/1/edit
  def edit
  end

  # POST /developers
  def create
    @developer = Developer.new(developer_params)

    respond_to do |format|
      if @developer.save
        format.html { redirect_to @developer, notice: 'Developer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /developers/1
  def update
    authorize! :update, @developer

    respond_to do |format|
      if @developer.update(developer_params)
        format.html { redirect_to @developer, notice: 'Developer was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /developers/1
  def destroy
    authorize! :destroy, @developer

    @developer.destroy
    respond_to do |format|
      format.html { redirect_to developers_url, notice: 'Developer was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_developer
      @developer = Developer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def developer_params
      params.require(:developer).permit(:name, :avatar, :github_id, :public_repos, :subscribers_count, :watchers_count, :forks_count)
    end
end
