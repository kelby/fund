class HomeController < ApplicationController
  def index
    @recommend_gems = Project.gemspec.where(today_recommend: true).order(recommend_at: :desc).limit(3)
    # @packages = Project.package.limit(3)
    @recommend_pods = Project.pod.where(today_recommend: true).order(recommend_at: :desc).limit(3)
  end
end
