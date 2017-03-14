class QuickrankPerformancesController < ApplicationController
  def index
    @rating_date = QuickrankPerformance.pluck(:rating_date).uniq.max

    @quickrank_performances = QuickrankPerformance.where(rating_date: @rating_date).includes(:project)
  end
end
