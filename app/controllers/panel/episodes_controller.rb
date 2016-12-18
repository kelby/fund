class Panel::EpisodesController < ApplicationController
  before_action :set_panel_episode, only: [:show, :edit, :update, :destroy]

  # GET /panel/episodes
  def index
    @panel_episodes = ::Episode.order(id: :desc).page(params[:page])
  end

  # GET /panel/episodes/1
  def show
  end

  # GET /panel/episodes/new
  def new
    @panel_episode = ::Episode.new
  end

  # GET /panel/episodes/1/edit
  def edit
  end

  # POST /panel/episodes
  def create
    @panel_episode = ::Episode.new(panel_episode_params)

    respond_to do |format|
      if @panel_episode.save
        format.html { redirect_to @panel_episode, notice: 'Episode was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /panel/episodes/1
  def update
    respond_to do |format|
      if @panel_episode.update(panel_episode_params)
        format.html { redirect_to @panel_episode, notice: 'Episode was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /panel/episodes/1
  def destroy
    @panel_episode.destroy
    respond_to do |format|
      format.html { redirect_to panel_episodes_url, notice: 'Episode was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel_episode
      @panel_episode = ::Episode.find_by(human_id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_episode_params
      params.fetch(:panel_episode, {})
    end
end
