class AgreementArticlesController < ApplicationController
  before_action :find_model
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @article = Article.find(params[:article_id])

    @agreement = AgreementArticle.find_or_create_by(user_id: current_user.id, article_id: @article.id)

    # if @agreement.blank?
      # @agreement = AgreementArticle.create(user_id: current_user.id, article_id: @article.id)
    # end
  end

  def destroy
    @article = Article.find(params[:article_id])

    @agreement = AgreementArticle.find_by(user_id: current_user.id, article_id: @article.id)

    if @agreement.present?
      @agreement.destroy
    end
  end

  private
  def find_model
    # @model = AgreementArticle.find(params[:id]) if params[:id]
  end
end