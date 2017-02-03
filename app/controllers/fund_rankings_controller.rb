class FundRankingsController < ApplicationController
  before_action :set_fund_ranking, only: [:show, :edit, :update, :destroy]

  # GET /fund_rankings
  # GET /fund_rankings.json
  def index
    @fund_rankings = FundRanking.all
  end

  # GET /fund_rankings/1
  # GET /fund_rankings/1.json
  def show
  end

  # GET /fund_rankings/new
  def new
    @fund_ranking = FundRanking.new
  end

  # GET /fund_rankings/1/edit
  def edit
  end

  # POST /fund_rankings
  # POST /fund_rankings.json
  def create
    @fund_ranking = FundRanking.new(fund_ranking_params)

    respond_to do |format|
      if @fund_ranking.save
        format.html { redirect_to @fund_ranking, notice: 'Fund ranking was successfully created.' }
        format.json { render :show, status: :created, location: @fund_ranking }
      else
        format.html { render :new }
        format.json { render json: @fund_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fund_rankings/1
  # PATCH/PUT /fund_rankings/1.json
  def update
    authorize! :update, @fund_ranking

    respond_to do |format|
      if @fund_ranking.update(fund_ranking_params)
        format.html { redirect_to @fund_ranking, notice: 'Fund ranking was successfully updated.' }
        format.json { render :show, status: :ok, location: @fund_ranking }
      else
        format.html { render :edit }
        format.json { render json: @fund_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fund_rankings/1
  # DELETE /fund_rankings/1.json
  def destroy
    authorize! :destroy, @fund_ranking

    @fund_ranking.destroy
    respond_to do |format|
      format.html { redirect_to fund_rankings_url, notice: 'Fund ranking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund_ranking
      @fund_ranking = FundRanking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_ranking_params
      params.require(:fund_ranking).permit(:project_id, :code, :name, :dwjz, :three_year_rating, :five_year_rating, :last_week_total_return, :last_week_ranking, :last_month_total_return, :last_month_ranking, :last_three_month_total_return, :last_three_month_ranking, :last_six_month_total_return, :last_six_month_ranking, :last_year_total_return, :last_year_ranking, :last_two_year_total_return, :last_two_year_ranking, :this_year_total_return, :this_year_ranking, :since_the_inception_total_return, :volatility, :volatility_evaluate, :risk_factor, :risk_factor_evaluate, :last_three_year_sharpe_ratio, :last_three_year_sharpe_ratio_evaluate)
    end
end
