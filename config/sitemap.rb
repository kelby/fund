# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://fund-toolbox.com"

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

  # 基金工具箱 - 首页
  add root_path, :priority => 0.9, :changefreq => 'weekly'


  # 基金 - 顶部导航
  add projects_path, :priority => 0.9, :changefreq => 'weekly'

  # 基金公司 - 顶部导航
  add catalogs_path, :priority => 0.9, :changefreq => 'weekly'

  # 基金经理 - 顶部导航
  add developers_path, :priority => 0.9, :changefreq => 'weekly'

  # 指数系列 - 顶部导航
  add index_reports_path, :priority => 0.9, :changefreq => 'weekly'

  # 文章 - 顶部导航
  add articles_path, :priority => 0.9, :changefreq => 'weekly'


  # 基金详情及相关
  Project.find_each do |project|
    add project_path(project), :lastmod => project.updated_at, :changefreq => 'weekly'

    # 增长率、收益计算
    add calculus_project_path(project), :changefreq => 'weekly'

    # 涨跌分布
    add distribute_project_path(project), :changefreq => 'weekly'
  end

  # 基金公司详情
  Catalog.find_each do |catalog|
    add catalog_path(catalog), :lastmod => catalog.updated_at, :changefreq => 'weekly'
  end

  # 基金经理详情
  Developer.find_each do |developer|
    add developer_path(developer), :lastmod => developer.updated_at, :changefreq => 'weekly'
  end

  # 文章详情
  Article.find_each do |article|
    add article_path(article), :lastmod => article.updated_at, :changefreq => 'weekly'
  end

  # 标签详情
  CustomTag.find_each do |tag|
    add tag_path(tag), :changefreq => 'weekly'
  end

  # 指数
  IndexReport::CATALOG_HASH.each_pair do |catalog_en, catalog_cn|
    # 指数 catalog
    add catalog_slug_index_reports_path(catalog_en), :changefreq => 'weekly', :priority => 0.5

    IndexReport.category_hash_under(catalog_en).each_pair do |category_en, category_cn|
      # 指数 category
      add catalog_slug_category_slug_index_reports_path(catalog_en, category_en), :changefreq => 'weekly', :priority => 0.5
    end
  end

  IndexReport.find_each do |index_report|
    # 指数详情
    add index_report_path(index_report), :changefreq => 'weekly', :priority => 0.5
  end

  # 晨星历史数据
  add history_quickrank_index_path, :priority => 0.9
  # 业绩和风险
  add performance_quickrank_index_path, :priority => 0.9
  # 投资组合
  add portfolio_quickrank_index_path, :priority => 0.9
  # 基金龙虎榜
  add snapshot_quickrank_index_path, :priority => 0.9
end
