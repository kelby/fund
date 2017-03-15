class QuickrankPortfoliosController < ApplicationController
  def index
    @rating_date = QuickrankPortfolio.pluck(:rating_date).uniq.max

    @quickrank_portfolios = QuickrankPortfolio.where(rating_date: @rating_date).includes(:project).page(params[:page]).per(1000)
  end
end
