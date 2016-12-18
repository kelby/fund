class Panel::EpisodesController < ApplicationController
  before_action :set_panel_episode, only: [:show, :edit, :update, :destroy]

  # GET /panel/episodes
  # GET /panel/episodes.json
  def index
    @panel_episodes = Panel::Episode.all
  end

  # GET /panel/episodes/1
  # GET /panel/episodes/1.json
  def show
  end

  # GET /panel/episodes/new
  def new
    @panel_episode = Panel::Episode.new
  end

  # GET /panel/episodes/1/edit
  def edit
  end

  # POST /panel/episodes
  # POST /panel/episodes.json
  def create
    @panel_episode = Panel::Episode.new(panel_episode_params)

    respond_to do |format|
      if @panel_episode.save
        format.html { redirect_to @panel_episode, notice: 'Episode was successfully created.' }
        format.json { render :show, status: :created, location: @panel_episode }
      else
        format.html { render :new }
        format.json { render json: @panel_episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panel/episodes/1
  # PATCH/PUT /panel/episodes/1.json
  def update
    respond_to do |format|
      if @panel_episode.update(panel_episode_params)
        format.html { redirect_to @panel_episode, notice: 'Episode was successfully updated.' }
        format.json { render :show, status: :ok, location: @panel_episode }
      else
        format.html { render :edit }
        format.json { render json: @panel_episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panel/episodes/1
  # DELETE /panel/episodes/1.json
  def destroy
    @panel_episode.destroy
    respond_to do |format|
      format.html { redirect_to panel_episodes_url, notice: 'Episode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_episode
      @panel_episode = Panel::Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_episode_params
      params.fetch(:panel_episode, {})
    end
end
