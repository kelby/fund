class FundYieldsController < ApplicationController
  before_action :set_fund_yield, only: [:show, :edit, :update, :destroy]

  # GET /fund_yields
  # GET /fund_yields.json
  def index
    @fund_yields = FundYield.all
  end

  # GET /fund_yields/1
  # GET /fund_yields/1.json
  def show
  end

  # GET /fund_yields/new
  def new
    @fund_yield = FundYield.new
  end

  # GET /fund_yields/1/edit
  def edit
  end

  # POST /fund_yields
  # POST /fund_yields.json
  def create
    @fund_yield = FundYield.new(fund_yield_params)

    respond_to do |format|
      if @fund_yield.save
        format.html { redirect_to @fund_yield, notice: 'Fund yield was successfully created.' }
        format.json { render :show, status: :created, location: @fund_yield }
      else
        format.html { render :new }
        format.json { render json: @fund_yield.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fund_yields/1
  # PATCH/PUT /fund_yields/1.json
  def update
    respond_to do |format|
      if @fund_yield.update(fund_yield_params)
        format.html { redirect_to @fund_yield, notice: 'Fund yield was successfully updated.' }
        format.json { render :show, status: :ok, location: @fund_yield }
      else
        format.html { render :edit }
        format.json { render json: @fund_yield.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fund_yields/1
  # DELETE /fund_yields/1.json
  def destroy
    @fund_yield.destroy
    respond_to do |format|
      format.html { redirect_to fund_yields_url, notice: 'Fund yield was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund_yield
      @fund_yield = FundYield.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_yield_params
      params.require(:fund_yield).permit(:project_id, :beginning_day, :end_day, :beginning_net_worth, :end_net_worth, :fund_chai_fens_count, :fund_fen_hongs, :yield_type, :yield_rate)
    end
end
