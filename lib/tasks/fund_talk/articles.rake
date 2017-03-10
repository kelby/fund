namespace :fund_talk do
  desc "articles search list, and show page."
  task :articles => [:environment] do
    sb ||= SpiderBase.new


    headless ||= Headless.new
    headless.start
    browser ||= Watir::Browser.new

    article_list_dir = Rails.public_path.join("article/fund_talk/list")
    FileUtils::mkdir_p(article_list_dir)

    article_show_dir = Rails.public_path.join("article/fund_talk/show")
    FileUtils::mkdir_p(article_show_dir)

    1.upto(7).each do |page|
      url = "http://weixin.sogou.com/weixin?usip=%E5%B0%8F5%E8%AE%BA%E5%9F%BA&query=%E5%B0%8F5%E8%AE%BA%E5%9F%BA&from=tool&ft=null&tsn=0&et=null&interation=null&type=2&wxid=oIWsFt6EgHyKG-6gEnaDhzKPJSx4&page=#{page}&ie=utf8"

      fetch_content = sb.page_for_url(url);
      doc = fetch_content.doc;


      list_file_name_with_path = article_list_dir.join("#{page}.html")


      begin
        File.open(list_file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{url}, Exception #{e}"
      end




      # 列表
      news_list_ele = doc.css(".news-list");

      if news_list_ele.present?
        # 列表
        article_list_ele = doc.css(".news-list").css("li");

        titles_ele = article_list_ele.map{|e| e.css(".txt-box h3 a") }

        titles_ele.each_with_index do |title_ele, index|
          article_url = title_ele.attr('href').value

          # fetch_content = sb.page_for_url(article_url)
          # article_doc = fetch_content.doc;
          puts "fetch article from #{article_url} ========= #{page}-#{index + 1}"
          browser.goto article_url


          title = browser.h2(id: "activity-name").text

          # article = Article.find_or_initialize_by(title: title)

          # if article.new_record?
          #   description = browser.div(class: "rich_media_meta_list").html
          #   description += browser.div(id: "js_content").html

          #   article.description = description
          #   article.user_id = User.first.id

          #   article.save
          # end

          show_file_name_with_path = article_show_dir.join("#{page}-#{index + 1}.html")

          begin
            File.open(show_file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
          rescue Exception => e
            puts "=============Error, Exception #{e}"
          end

        end
      end
    end

    # url = "http://weixin.sogou.com/weixin?usip=%E5%B0%8F5%E8%AE%BA%E5%9F%BA&query=%E5%B0%8F5%E8%AE%BA%E5%9F%BA&from=tool&ft=null&tsn=0&et=null&interation=null&type=2&wxid=oIWsFt6EgHyKG-6gEnaDhzKPJSx4&page=6&ie=utf8"
  end
end
