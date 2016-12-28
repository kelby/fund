# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://dev-toolbox.co"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
            # :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # Add '/articles'
  #
  add root_path, :priority => 0.7, :changefreq => 'daily'
  add rails_path, :priority => 0.7, :changefreq => 'daily'
  add swift_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  Project.show_status.find_each do |project|
    add repo_path(project.repo_params), :lastmod => project.updated_at
  end

  Episode.online.find_each do |episode|
    add episode_path(episode), :lastmod => episode.updated_at
  end

  Catalog.online.find_each do |catalog|
    add catalog_path(catalog), :lastmod => catalog.updated_at
  end

  Category.online.find_each do |category|
    add category_path(category), :lastmod => category.updated_at
  end
end
