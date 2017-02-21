class TagsController < ApplicationController
  def index
  end

  def show
    @tag = CustomTag.find_by(slug: params[:id])

    if @tag.blank?
      @tag = CustomTag.find(params[:id])
    end

    @projects = Project.tagged_with(@tag.name).by_join_date.page(params[:page]).per(40)
  end
end
