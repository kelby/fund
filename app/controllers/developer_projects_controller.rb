class DeveloperProjectsController < ApplicationController
  before_filter :find_model

  def destroy
    authorize! :destroy, @model

    @model.destroy

    redirect_back fallback_location: managers_project_url(@model.project), notice: "就职记录移除成功"
  end

  private
  def find_model
    @model = DeveloperProject.find(params[:id]) if params[:id]
  end
end