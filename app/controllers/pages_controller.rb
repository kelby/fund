class PagesController < ApplicationController
  before_filter :find_model

  def show

    # render params[:name] if params[:name]
  end

  private
  def find_model
    # @model = Page.find(params[:name]) if params[:name]
  end
end