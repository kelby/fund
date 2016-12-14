require 'nokogiri'
require 'open-uri'

# awesome-*
# https://www.ruby-toolbox.com/

# https://github.com/tuwannu/awesome-laravel#popularnotable-packages

namespace :ruby_tool do
  desc "index page"
  task :index_page => [:environment] do
    doc = Nokogiri::HTML(` curl 'https://www.ruby-toolbox.com/' `)

    if doc.present?
      title_array = doc.css("#content h4")
      content_array = doc.css("#content h4+.group_items")

      title_array.map{|x| x.content.strip }.each_with_index do |name, index|
        catalog = RailsCatalog.find_or_initialize_by(name: name)

        catalog.slug = Pinyin.t(name, splitter: '_')

        if catalog.changed?
          catalog.save
        end

        Rails.logger.info(index)
        Rails.logger.info("==================")
        content_array_2 = content_array[index]



          y = content_array_2.css("li > a")


          y.each do |yy|
            # z = yy.attribute("href").value.split("/").last
            z = yy.children[0].text.strip

            category = catalog.categories.find_or_initialize_by(name: z)
            category.slug = Pinyin.t(z, splitter: '_')

            if category.changed?
              category.save
            end

            w = yy.children[1]
            ws = w.text.split(",")

            if ws.last =~ /more$/
              ws.pop
            end

            ws.each do |project_name|
              delay = rand(1..3600)
              Project.delay_for(delay).get_and_create_gem_project(project_name, category.id)
            end
          end
      end
    end
  end

  desc "get projects from categories"
  task :get_projects => [:environment] do
    categories = Category.all.joins(:catalog).where(catalogs: {type: "RailsCatalog"}).uniq

    categories.each do |category|
      delay = rand(1..600)
      Category.delay_for(delay).delay_get_projects(category.id)

      # category_name = category.slug.try(:downcase)
      # url = "https://www.ruby-toolbox.com/categories/#{category_name}"

      # doc = Nokogiri::HTML(` curl "#{url}" `)

      # if doc.present?
      #   source_codes = doc.css("a.source_code")

      #   next if source_codes.blank?

      #   source_codes.each do |source_code|
      #     project_name = source_code.attributes['href'].value
      #     delay = rand(1..3600)
      #     Project.delay_for(delay).get_and_create_gem_project(project_name, category.id)
      #   end
      # end
    end
  end

  desc "markets/awesome-ruby"
  task :markets_awesome_ruby => [:environment] do
    doc = Nokogiri::HTML(open "https://github.com/markets/awesome-ruby/");

    links = doc.css(".markdown-body ul > li > a");
    link_links = links.map{|x| x.attributes['href'].value }.select{|x| x=~ /github\.com/}

    link_links.each do |link|
      text = link.attributes['href'].value

      if text =~ /github\.com/
        delay = rand(1..300)
        Project.delay_for(delay).get_and_create_gem_project_from_option({'source_code' => text, 'identity' => Project.identities['gem']})
      else
        next
      end
    end
  end
end

namespace :packagist do
  desc "tags laravel"
  task :tags_laravel => [:environment] do
    (1..10).each do |i|
      if i == 1
        url = "https://packagist.org/search/?tags=laravel"
      else
        "https://packagist.org/search/?tags=laravel&page=#{i}"
      end

      doc = Nokogiri::HTML(open url)

      if doc.present?
        x = doc.css("ul.packages > li")

        x.each do |xx|
          y = xx
          z = y.attribute("data-url").value

          vendor, package = z.split("/").last(2)
          github_url = PackageInfo.get_project_github_url(vendor, package)

          delay = rand(1..3600)
          Project.delay_for(delay).create(source_code: github_url, identity: Project.identities['package'])
        end
      end
    end
  end
end

namespace :swift do
  desc "matteocrippa awesome-swift"
  task :matteocrippa => [:environment] do
    doc = Nokogiri::HTML(open "https://github.com/matteocrippa/awesome-swift")


    h3_titles = doc.css(".markdown-body h3")

    h3_titles.each_with_index do |h3_title, index|
      if index < 2
        next
      end

      catalog = SwiftCatalog.find_or_create_by(name: h3_title.text)
      Category.find_or_create_by(name: h3_title.text, catalog_id: catalog.id)
    end

    h4_titles = doc.css(".markdown-body h4")
    h4_titles.each do |h4_title|
      Category.find_or_create_by(name: h4_title.text)
    end


    catalog_category = doc.css(".markdown-body ul").first

    catalog_category.children.each do |child|
      if child.name != 'li'
        next
      end

      catalog_name = child.css("a").first.text
      catalog = SwiftCatalog.find_or_create_by(name: child.css("a").first.text)

      if catalog_name == "Libs"
        child.css("ul > li").each do |li|
          catalog = Catalog.find_or_create_by(name: li.css("a").first.text)
          # category.catalog_id = catalog.id
          # category.save

          li.css("ul > li").each do |li_child|
            category = Category.find_or_create_by(name: li_child.css("a").first.text)
            category.catalog_id = catalog.id
            category.save
          end
        end
      else
        child.css("ul > li").each do |li|
          category = Category.find_or_create_by(name: li.css("a").first.text)
          category.catalog_id = catalog.id
          category.save
        end
      end
    end
  end

  desc "set matteocrippa projects"
  task :set_matteocrippa_projects => [:environment] do
    doc = Nokogiri::HTML(open "https://github.com/matteocrippa/awesome-swift");
    
    links = doc.css(".markdown-body ul li a")
    links.each do |link_ele|
      if link_ele.attributes['href'].value =~ /github\.com/
        ul = link_ele.parent.parent

        if ul.node_name == "ul"
          h3_ele = ul.previous_sibling.previous_sibling.previous_sibling
          if h3_ele.node_name == "h3"
            # ...
          else
            h3_ele = ul.previous_sibling.previous_sibling.previous_sibling.previous_sibling
            if h3_ele.node_name == "h3"
              # ...
            else
              next
            end
          end

          category = Category.find_or_create_by(name: h3_ele.text)
          github_url = link_ele.attributes['href'].value

          delay = rand(1..600)
          Project.delay_for(delay).get_and_create_pod_project(github_url, category.id)
        else
          next
        end
      else
        next
      end
    end
  end

  desc "Task description"
  task :task_name => [:environment] do
    doc = Nokogiri::HTML(open "https://github.com/matteocrippa/awesome-swift");
    
    lis = doc.css(".markdown-body h4");

    lis.each do |li|
      ul_ul = li.next_element.next_element

      if ul_ul.node_name == "ul"
        links = ul_ul.css("li > a")

        links.each do |link_ele|
          github_url = link_ele.attributes['href'].value

          if github_url =~ /github\.com/
            name = li.text
            category = Category.joins(:catalog).where(catalogs: {type: "SwiftCatalog"}).where(name: name).last

            if category.present?
              delay = rand(1..600)
              Project.delay_for(delay).get_and_create_pod_project(github_url, category.id)
            else
              next
            end
          else
            next
          end
        end
      else
        next
      end
    end
  end

  desc "set Wolg awesome-swift"
  task :set_wolg_awesome_swift => [:environment] do
    url = "https://github.com/Wolg/awesome-swift"

    doc = Nokogiri::HTML(open url);

    xs = doc.css(".markdown-body h2");
    xs.size

    xs.each do |x|
      if x.next_element.node_name == "ul"
        name = x.text

        catalog = SwiftCatalog.find_or_create_by(name: name)

        category = catalog.categories.find_or_create_by(name: name)

        y = x.next_element

        links = y.css("li > a")

        links.each do |link|
          github_url = link.attributes['href'].value

          if github_url =~ /github\.com/
            delay = rand(1..600)
            Project.delay_for(delay).get_and_create_pod_project(github_url, category.id)
          else
            next
          end

        end
      else
        next
      end
    end
  end

  desc "get pod projects"
  task :get_pod_projects => [:environment] do
    category_id = nil

    %W(
    ).each do |github_url|
      Project.delay.get_and_create_pod_project(github_url, category_id)
    end

    Category.find(category_id).projects.map do |project|
      project.destroy if project.github_info.blank?
      project.destroy if project.pod_info.blank?
    end

  end
end
