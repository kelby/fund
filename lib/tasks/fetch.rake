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
  task :get_projects_from_ruby_toolbox => [:environment] do
    categories = Category.all.joins(:catalog).where(catalogs: {type: "RailsCatalog"}).uniq

    categories.each do |category|
      delay = rand(1..7200)
      Category.delay_for(delay).delay_get_projects(category.id)
    end
  end

  desc "markets/awesome-ruby"
  task :markets_awesome_ruby => [:environment] do
    doc = Nokogiri::HTML(open "https://github.com/markets/awesome-ruby/");

    links = doc.css(".markdown-body ul > li > a");
    link_links = links.map{|x| x.attributes['href'].value }.select{|x| x=~ /github\.com/};

    link_links.each do |link|
      # text = link.attributes['href'].value

      # if text =~ /github\.com/
        delay = rand(1..300)
        Project.delay_for(delay).get_and_create_gem_project_from_option({'source_code' => link, 'identity' => Project.identities['gemspec']})
      # else
        # next
      # end
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

  desc "matteocrippa matteocrippa/awesome-swift"
  task :all_github_link => [:environment] do
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

  desc "vsouza awesome-ios H1类目及其下面的项目"
  task :vsouza_awesome_ios_h1 => [:environment] do
    url = "https://github.com/vsouza/awesome-ios"

    doc = Nokogiri::HTML(open url);

    @categories = Category.includes(:catalog).where(catalogs: {type: 'SwiftCatalog'})

    xs = doc.css(".markdown-body h1");
    
    xs.each do |xx|
      xxname = xx.text
      yy = xx.next_element

      if yy.name != "ul"
        yy = xx.next_element.next_element
      end

      if yy.name == "ul"
        links = yy.css("li > a")

        # 找子类目
        category = @categories.where(name: xxname).last

        # 找不到
        if category.blank?
          # 找父类目
          catalog = Catalog.where(type: 'SwiftCatalog').where(name: xxname).last

          # 找不到
          if catalog.blank?
            # 创建父类目
            catalog = Catalog.create(type: 'SwiftCatalog', name: xxname)
          else
            # 找到父类目
          end

          # 创建子类目
          category = catalog.categories.create(name: xxname)
        else
          # 找到子类目
        end

        category_id = category.id

        links.each do |link|
          github_url = link.attributes['href'].value

          if github_url =~ /github\.com/
            delay = rand(1..1800)
            Project.delay_for(delay).get_and_create_pod_project(github_url, category_id)
          end
        end
      else
        next
      end
    end
  end

  desc "vsouza awesome-ios H2类目及其下面的项目"
  task :vsouza_awesome_ios_h2 => [:environment] do
    url = "https://github.com/vsouza/awesome-ios"

    doc = Nokogiri::HTML(open url);

    @categories = Category.includes(:catalog).where(catalogs: {type: 'SwiftCatalog'})

    xs = doc.css(".markdown-body h2");
    
    xs.each do |xx|
      xxname = xx.text
      yy = xx.next_element

      if yy.name != "ul"
        yy = xx.next_element.next_element
      end

      if yy.name == "ul"
        links = yy.css("li > a")

        # 找子类目
        category = @categories.where(name: xxname).last

        # 找不到
        if category.blank?
          # 找父类目
          catalog = Catalog.where(type: 'SwiftCatalog').where(name: xxname).last

          # 找不到
          if catalog.blank?
            # 创建父类目
            catalog = Catalog.create(type: 'SwiftCatalog', name: xxname)
          else
            # 找到父类目
          end

          # 创建子类目
          category = catalog.categories.create(name: xxname)
        else
          # 找到子类目
        end

        category_id = category.id

        links.each do |link|
          github_url = link.attributes['href'].value

          if github_url =~ /github\.com/
            delay = rand(1..1800)
            Project.delay_for(delay).get_and_create_pod_project(github_url, category_id)
          end
        end
      else
        next
      end
    end
  end

  # 有bug
  desc "vsouza awesome-ios H4类目及其下面的项目"
  task :vsouza_awesome_ios_h4 => [:environment] do
    url = "https://github.com/vsouza/awesome-ios"

    doc = Nokogiri::HTML(open url);

    @categories = Category.includes(:catalog).where(catalogs: {type: 'SwiftCatalog'})

    xs = doc.css(".markdown-body h4");

    xs.each do |xx|
      xxname = xx.text

      xx_father = xx.previous_element

      if xx_father.name == "h2"
        xx_fathername = xx_father.text
      else
        xx_father = xx.previous_element.previous_element

        if xx_father.name == "h2"
          xx_fathername = xx_father.text
        elsif xx_father.name == "h4"
          xx_father = xx_father.previous_element.previous_element
          if xx_father.name == "h2"
            xx_fathername = xx_father.text
          end
        else
          xx_father = xx.previous_element.previous_element.previous_element
          if xx_father.name == "h2"
            xx_fathername = xx_father.text
          end
        end
      end


      yy = xx.next_element

      if yy.name == "ul"
        links = yy.css("li > a")

        # 找子类目
        category = @categories.where(name: xxname).last

        # 找不到
        if category.blank?
          # 找类似子类目
          similar_category = @categories.where(name: xx_fathername).last

          # 找到类似子类目
          if similar_category.present?
            # 认其父类做父类
            catalog = similar_category.catalog
          else
            # 找不到类目子类目，开始找类目父类目
            catalog = Catalog.where(type: 'SwiftCatalog').where(name: xx_fathername).last

            if catalog.blank?
              catalog = Catalog.create(type: 'SwiftCatalog', name: xx_fathername)
            end
          end

          category = catalog.categories.create(name: xxname)
        end

        category_id = category.id

        links.each do |link|
          github_url = link.attributes['href'].value

          if github_url =~ /github\.com/
            delay = rand(1..1800)
            Project.delay_for(delay).get_and_create_pod_project(github_url, category_id)
          end
        end
      else
        next
      end
    end
  end

  # 有bug
  desc "vsouza awesome-ios H4类目及其下面的项目"
  task :vsouza_awesome_ios_h4_for_h1 => [:environment] do
    url = "https://github.com/vsouza/awesome-ios"

    doc = Nokogiri::HTML(open url);

    @categories = Category.includes(:catalog).where(catalogs: {type: 'SwiftCatalog'})

    xs = doc.css(".markdown-body h4");

    xs.each do |xx|
      xxname = xx.text

      xx_father = xx.previous_element

      if xx_father.name == "h1"
        xx_fathername = xx_father.text
      else
        xx_father = xx.previous_element.previous_element

        if xx_father.name == "h1"
          xx_fathername = xx_father.text
        elsif xx_father.name == "h4"
          xx_father = xx_father.previous_element.previous_element
          if xx_father.name == "h1"
            xx_fathername = xx_father.text
          end
        else
          xx_father = xx.previous_element.previous_element.previous_element
          if xx_father.name == "h1"
            xx_fathername = xx_father.text
          end
        end
      end


      yy = xx.next_element

      if yy.name == "ul"
        links = yy.css("li > a")

        # 找子类目
        category = @categories.where(name: xxname).last

        # 找不到
        if category.blank?
          # 找类似子类目
          similar_category = @categories.where(name: xx_fathername).last

          # 找到类似子类目
          if similar_category.present?
            # 认其父类做父类
            catalog = similar_category.catalog
          else
            # 找不到类目子类目，开始找类目父类目
            catalog = Catalog.where(type: 'SwiftCatalog').where(name: xx_fathername).last

            if catalog.blank?
              catalog = Catalog.create(type: 'SwiftCatalog', name: xx_fathername)
            end
          end

          category = catalog.categories.create(name: xxname)
        end

        category_id = category.id

        links.each do |link|
          github_url = link.attributes['href'].value

          if github_url =~ /github\.com/
            delay = rand(1..1800)
            Project.delay_for(delay).get_and_create_pod_project(github_url, category_id)
          end
        end
      else
        next
      end
    end
  end


  desc "vsouza awesome-ios 所有github链接，后续再归类。。。"
  task :vsouza_awesome_ios_all => [:environment] do
    url = "https://github.com/vsouza/awesome-ios"

    doc = Nokogiri::HTML(open url);

    xs = doc.css(".markdown-body ul > li > a");
    xs.size

    xs.each do |xx|
      github_url = xx.attributes['href'].value

      if github_url =~ /github\.com/
        delay = rand(1..10086)
        Project.delay_for(delay).get_and_create_gem_project_from_option(source_code: github_url, identity: Project.identities['pod'])
      end
    end
  end
end
