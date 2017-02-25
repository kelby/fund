class FundChaiFensController < ApplicationController
  before_filter :find_model

  def index
    @fund_chai_fens = FundChaiFen.order(break_convert_at: :desc).includes(:project).page(params[:page]).per(100)
  end

  private
  def find_model
    @model = FundChaiFen.find(params[:id]) if params[:id]
  end
end