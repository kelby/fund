class HomeController < ApplicationController
  before_action :get_today_recommend_projects, only: [:index]
  layout 'one_page'

  def index
  end
end
