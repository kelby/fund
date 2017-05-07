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

    search_type = params[:search_type]
    search_method = "search_#{search_type}".to_sym



    if self.class.private_instance_methods.include?(search_method)
      send(search_method)
    end

    # if params[:year].present? && params[:month_day].present? #{ }"year"=>"2015", "month_day"=>"12-25"
      # date_history = "#{params[:year]}-#{params[:month_day]}"

      # return redirect_to date_history_quickrank_index_url()

      # @fund_rankings = FundRanking.where(record_at: date_history).includes(:project) # .page(params[:page]).per(500)
    # end

    render "#{search_type}/index"
  end

  private

  def search_fund_rankings
    @rating_date ||= FundRanking.pluck(:record_at).uniq.max


    @fund_rankings = FundRanking.where(record_at: @rating_date).includes(:project)

    if params[:three_year_rating].present?
      three_year_rating = params[:three_year_rating]

      if three_year_rating.to_i.zero?
        @fund_rankings = @fund_rankings.where(three_year_rating: nil)
      else
        @fund_rankings = @fund_rankings.where(three_year_rating: three_year_rating)
      end
    end

    if params[:five_year_rating].present?
      five_year_rating = params[:five_year_rating]

      if five_year_rating.to_i.zero?
        @fund_rankings = @fund_rankings.where(five_year_rating: nil)
      else
        @fund_rankings = @fund_rankings.where(five_year_rating: five_year_rating)
      end
    end

    if params[:company_id].present?
      @fund_rankings = @fund_rankings.joins(:project).where(projects: {catalog_id: params[:company_id]})
    end
  end

  # 基金龙虎榜
  def search_quickrank_snapshots
    @rating_date = QuickrankSnapshot.pluck(:rating_date).uniq.max

    @quickrank_snapshots = QuickrankSnapshot.where(rating_date: @rating_date).includes(:project).page(params[:page]).per(1000)

    if params[:three_year_rating].present?
      @quickrank_snapshots = @quickrank_snapshots.where(star_rating_three_year: params[:three_year_rating])
    end

    if params[:five_year_rating].present?
      @quickrank_snapshots = @quickrank_snapshots.where(star_rating_five_year: params[:five_year_rating])
    end

    if params[:delivery_style].present?
      project_ids = QuickrankPortfolio.where(rating_date: @rating_date).where(delivery_style: params[:delivery_style]).pluck(:project_id)

      @quickrank_snapshots = @quickrank_snapshots.where(project_id: project_ids)
    end
  end

  # 业绩和风险
  def search_quickrank_performances
    @rating_date = QuickrankPerformance.pluck(:rating_date).uniq.max

    @quickrank_performances = QuickrankPerformance.where(rating_date: @rating_date).includes(:project).page(params[:page]).per(1000)

    if params[:three_year_rating].present?
      three_year_rating_project_ids = @quickrank_snapshots = QuickrankSnapshot.where(rating_date: @rating_date).pluck(:project_id)
      @quickrank_performances = @quickrank_performances.where(project_id: three_year_rating_project_ids)
    end

    if params[:five_year_rating].present?
      five_year_rating_project_ids = @quickrank_snapshots = QuickrankSnapshot.where(rating_date: @rating_date).pluck(:project_id)
      @quickrank_performances = @quickrank_performances.where(project_id: five_year_rating_project_ids)
    end

    if params[:delivery_style].present?
      project_ids = QuickrankPortfolio.where(rating_date: @rating_date).where(delivery_style: params[:delivery_style]).pluck(:project_id)
      @quickrank_performances = @quickrank_performances.where(project_id: project_ids)
    end
  end

  # 投资组合
  def search_quickrank_portfolios
    @rating_date = QuickrankPortfolio.pluck(:rating_date).uniq.max

    @quickrank_portfolios = QuickrankPortfolio.where(rating_date: @rating_date).includes(:project).page(params[:page]).per(1000)

    if params[:delivery_style].present?
      delivery_style = params[:delivery_style]

      if delivery_style.to_i.zero?
        @quickrank_portfolios = @quickrank_portfolios.where(delivery_style: nil)
      else
        @quickrank_portfolios = @quickrank_portfolios.where(delivery_style: delivery_style)
      end
    end
  end
end
