class NetWorthsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token

  def create
    project = Project.find_by(code: params[:project_code])

    return if project.blank?

    @net_worth = project.net_worths.create(net_worth_params)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def net_worth_params
      params.require(:net_worth).permit(:record_at, :dwjz, :ljjz, :accnav, :project_id)
    end
end

