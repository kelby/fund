class ProjectArithmeticController < ApplicationController
  before_action :set_project

  def calculus
    @fund_yields = @project.fund_yields.order(yield_type: :asc)
  end

  private
  def set_project
    # debugger
    get_code = params[:id].split("-").first
    @project = Project.find_by(code: get_code)
  end
end
