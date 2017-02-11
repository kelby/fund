class ProjectArithmeticController < ApplicationController
  before_action :set_project

  def calculus
  end

  private
  def set_project
    # debugger
    get_code = params[:id].split("-").first
    @project = Project.find_by(code: get_code)
  end
end
