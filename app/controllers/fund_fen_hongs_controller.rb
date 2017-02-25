class FundFenHongsController < ApplicationController
  before_filter :find_model

  def index
    @projects = Project.order(fund_fen_hongs_count: :desc).joins(:fund_fen_hongs).distinct.page(params[:page]).per(100)
  end

  def list
    @fund_fen_hongs = FundFenHong.order(ex_dividend_at: :desc).includes(:project).page(params[:page]).per(100)
  end

  private
  def find_model
    @model = FundFenHong.find(params[:id]) if params[:id]
  end
end