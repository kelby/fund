require 'nokogiri'
require 'open-uri'

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
end

namespace :packagist do
  desc "tags laravel"
  task :tags_laravel => [:dependent, :tasks] do
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