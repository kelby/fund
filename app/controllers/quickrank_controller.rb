class QuickrankController < ApplicationController
  def history
    # {"year"=>"2014"}
    # if params[:year].present?
      year = params[:year]

      year = "#{year}-01-01".to_time
    # end

    @data = FundRanking.record_at_month_day_by(year)
  end

  # def date_history
    # debugger
  # end

  def show
    # debugger
  end

  def search
    # debugger

    if params[:year].present? && params[:month_day].present? #{ }"year"=>"2015", "month_day"=>"12-25"
      date_history = "#{params[:year]}-#{params[:month_day]}"

      # return redirect_to date_history_quickrank_index_url()

      @fund_rankings = FundRanking.where(record_at: date_history).includes(:project) # .page(params[:page]).per(500)
    end
  end
end