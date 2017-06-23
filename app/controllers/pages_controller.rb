class PagesController < ApplicationController
  before_filter :find_model

  def show

    # render params[:name] if params[:name]
  end

  def search
    # @result = ...


      params[:q] ||= ''

      search_modules = [Project, Developer, Catalog, IndexReport, Article]

      search_params = {
        query: {
          simple_query_string: {
            query: params[:q],
            default_operator: 'AND',
            minimum_should_match: '70%',
            fields: %w(title body name login description)
          }
        },
        highlight: {
          pre_tags: ['[h]'],
          post_tags: ['[/h]'],
          fields: { title: {}, body: {}, name: {}, login: {}, description: {} }
        }
      }

      @result = Elasticsearch::Model.search(search_params, search_modules).page(params[:page])


  end

  private
  def find_model
    # @model = Page.find(params[:name]) if params[:name]
  end
end