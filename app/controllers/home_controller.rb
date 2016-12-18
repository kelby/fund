class HomeController < ApplicationController
  before_action :get_today_recommend_projects, only: [:index]

  def index
  end
end
