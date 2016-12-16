class ProjectSearchController < ApplicationController
  def old_index
    projects = Project.show_status

    if params[:type].present?
      projects = projects.where(identity: params[:type])
    end

    @projects = projects.where("name LIKE ?", "%#{params[:q]}%").page(params[:page]).per(20)
  end

  def index
    filter = []
    must = []
    should = []


    if params[:type].present?
      filter << {term: { identity: params[:type] } }
    else
      filter << {terms: { identity: ['gemspec', 'package', 'pod'] } }
    end

    filter << {terms: { status: ['online', 'nightspot', 'deprecated'] } }


    if params[:q].present?
      query = params[:q]

      _multi_match_fields = {
          multi_match: {
            query: query,
            fields: [ "name", "given_name", "human_name", "description" ],
            analyzer: "ik_smart"
          }
        }

      must << _multi_match_fields

      _category_name = {match: {
                  :"category.name" => query
                }}

      _category_slug = {match: {
                  :"category.slug" => query
                }}


      must << _category_name
      must << _category_slug
    else
      must << { match_all: {} }
    end

    search_params = {
      query: {
        bool: {
          filter: filter,
          must: {bool: {should: must} }
        }
      }
    }


    @projects = Project.includes(:github_info, :category => :catalog).search(search_params).page(params[:page]).per(20).records

    @count = @projects.total_count
  end
end
