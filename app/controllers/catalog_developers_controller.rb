class CatalogDevelopersController < ApplicationController
  def index
    @catalog = Catalog.find(params[:catalog_id])

    @online_developers = @catalog.online_developers.includes(:catalogs)
    @offline_developers = @catalog.offline_developers.includes(:catalogs)
  end
end
