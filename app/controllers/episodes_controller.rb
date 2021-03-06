class EpisodesController < ApplicationController
  before_action :set_episode, only: [:edit, :update, :destroy]
  before_action :get_today_recommend_projects, only: [:show, :today]
  before_action :get_recommend_description, only: [:show, :today]

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.online.desc_human.recommend_before_today

    _project_ids = @episodes.pluck(:project_list).map{|x| x.split(",") }
    project_ids  = _project_ids.flatten.map(&:to_i)

    projects = Project.online.where(id: project_ids).includes(:github_info, :category => :catalog)

    # @recommend_gems = projects.gemspec.includes(:github_info, :category => :catalog)

    # @recommend_pods = projects.pod.includes(:github_info, :category => :catalog)
  end

  def today
    render :show
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
  end

  # GET /episodes/new
  def new
    @episode = Episode.new
  end

  # GET /episodes/1/edit
  def edit
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.new(episode_params)

    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode, notice: 'Episode was successfully created.' }
        format.json { render :show, status: :created, location: @episode }
      else
        format.html { render :new }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    authorize! :update, @episode

    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
        format.json { render :show, status: :ok, location: @episode }
      else
        format.html { render :edit }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.json
  def destroy
    authorize! :destroy, @episode

    @episode.destroy
    respond_to do |format|
      format.html { redirect_to episodes_url, notice: 'Episode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find_by(human_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:human_id, :project_list)
    end

    def get_recommend_description
      if @recommend_gems.present? && @recommend_pods.present?
        @recommend_description = "#{@recommend_gems.pluck(:name).join('、')}，#{@recommend_pods.pluck(:name).join('、')}"
      elsif @recommend_gems.blank? && @recommend_pods.present?
        @recommend_description = "#{@recommend_pods.pluck(:name).join('、')}"
      elsif @recommend_pods.blank? && @recommend_gems.present?
        @recommend_description = "#{@recommend_gems.pluck(:name).join('、')}"
      end
    end
end
