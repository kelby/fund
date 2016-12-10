class HomeController < ApplicationController
  def index
    @gems = Project.gem.limit(3)
    # @packages = Project.package.limit(3)
    @pods = Project.pod.limit(3)
  end
end
