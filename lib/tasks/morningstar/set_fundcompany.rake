namespace :morningstar do
  desc "Task description"
  task :set_fundcompany => [:environment] do
    # ...
  end

  namespace :set do
    # def browser
    #   headless ||= Headless.new
    #   headless.start

    #   # mkdir_fundcompany

    #   @browser ||= Watir::Browser.new
    # end

    def url
      "http://cn.morningstar.com/fundcompany/default.aspx"
    end

    def fundcompany_dir
      Rails.public_path.join("fund/morningstar/fundcompany/")
    end

    # def mkdir_fundcompany
    #   FileUtils::mkdir_p(fundcompany_dir)
    # end

    # 快照
    desc "fundcompany_snapshots"
    task :fundcompany_snapshots => [:environment] do      
      file_name_with_path = fundcompany_dir.join("fundcompany_snapshots.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|

        tds_ele = x.css("td")

        name = tds_ele[1].css("a").text
        city = tds_ele[2].text
        set_up_at = tds_ele[3].text
        scale = tds_ele[4].text
        funds_count = tds_ele[5].text
        managers_count = tds_ele[6].text
        tenure_avg = tds_ele[7].text
        this_year_best_fund_id = tds_ele[8].css("a").text
        this_year_best_fund_total_return = tds_ele[9].text

        FundcompanySnapshot.create(
          name: name,
          city: city,
          set_up_at: set_up_at,
          scale: scale,
          funds_count: funds_count,
          managers_count: managers_count,
          tenure_avg: tenure_avg,
          this_year_best_fund_id: this_year_best_fund_id,
          this_year_best_fund_total_return: this_year_best_fund_total_return)

      end
    end

    # 基金经理
    desc "fundcompany_managers"
    task :fundcompany_managers => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_managers.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      end
    end

    # 星级分布
    desc "fundcompany_stars"
    task :fundcompany_stars => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_stars.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|

        tds_ele = x.css("td")

        name = tds_ele[1].css("a").text
        funds_count = tds_ele[2].text
        five_star_count = tds_ele[3].text
        four_star_count = tds_ele[4].text
        three_star_count = tds_ele[5].text
        two_star_count = tds_ele[6].text
        one_star_count = tds_ele[7].text
        none_star_count = tds_ele[8].text

        FundcompanyStar.create(
          name: name,
          funds_count: funds_count,
          five_star_count: five_star_count,
          four_star_count: four_star_count,
          three_star_count: three_star_count,
          two_star_count: two_star_count,
          one_star_count: one_star_count,
          none_star_count: none_star_count )

      end
    end

    # 最佳业绩
    desc "fundcompany_best_returns"
    task :fundcompany_best_returns => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_best_returns.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
        tds_ele = x.css("td")

        name = tds_ele[1].css("a").text
        return_inception_id
        return_inception = tds_ele[3].text
        three_year_return_inception_id
        three_year_return_inception = tds_ele[3].text
        this_year_return_inception_id
        this_year_return_inception = tds_ele[3].text

        FundcompanyBestReturn.create(name: name,
          return_inception_id: return_inception_id,
          return_inception: return_inception,
          three_year_return_inception_id: three_year_return_inception_id,
          three_year_return_inception: three_year_return_inception,
          this_year_return_inception_id: this_year_return_inception_id,
          this_year_return_inception: this_year_return_inception)
      end
    end

    # 业绩分布
    desc "fundcompany_performances"
    task :fundcompany_performances => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_performances.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
        tds_ele = x.css("td")

        name = tds_ele[1].css("a").text
        rank_pre_one_four = tds_ele[2].text
        rank_pre_one_two = tds_ele[3].text
        rank_post_one_four = tds_ele[4].text
        rank_post_one_two = tds_ele[5].text
        return_lt_zero = tds_ele[6].text
        return_zero_to_ten = tds_ele[7].text
        return_ten_to_twenty = tds_ele[8].text
        return_twenty_to_thirty = tds_ele[9].text
        return_thirty_to_fifty = tds_ele[10].text
        return_gt_fifty = tds_ele[11].text

        FundcompanyPerformance.create(
        name: name,
        rank_pre_one_four: rank_pre_one_four,
        rank_pre_one_two: rank_pre_one_two,
        rank_post_one_four: rank_post_one_four,
        rank_post_one_two: rank_post_one_two,
        return_lt_zero: return_lt_zero,
        return_zero_to_ten: return_zero_to_ten,
        return_ten_to_twenty: return_ten_to_twenty,
        return_twenty_to_thirty: return_twenty_to_thirty,
        return_thirty_to_fifty: return_thirty_to_fifty,
        return_gt_fifty: return_gt_fifty)
      end
    end

    # 资产分布
    desc "fundcompany_assets"
    task :fundcompany_assets => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_assets.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      end
    end

    # 基本信息
    desc "fundcompany_infos"
    task :fundcompany_infos => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_infos.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      end
    end

    desc "fundcompanies"
    task :fundcompanies => [:environment] do

      file_name_with_path = fundcompany_dir.join("fundcompany_snapshots.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text
      puts doc.css("tr.gridAlternateItem, tr.gridItem").size

      valid_names = []
      invalid_names = []
      blank_names = []

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
        text_ele = x.css("td")[1]

        # Fundcompany
        # project_id

        morningstar_name = text_ele.text
        morningstar_number = text_ele.css("a").attr("href").value.scan(/\d{1,99}$/)[0]

        like_name = morningstar_name.gsub(/基金$/, "")
        catalogs = Catalog.where("name LIKE ? OR short_name LIKE ?", like_name, like_name)

        if catalogs.one?
          # Fundcompany.create(morningstar_name: morningstar_name, morningstar_number: morningstar_number,
            # project_id: catalogs.first)
          valid_names << like_name
        elsif catalogs.many?
          puts "name #{like_name}"
          puts "like many catalogs: #{catalogs.ids.join(', ')}, #{catalogs.pluck(:name).join(', ')}"

          invalid_names << like_name
        else
          blank_names << like_name
        end
      end

      puts "#{valid_names.size} valid_names"
      puts "#{invalid_names.size} invalid_names, they are #{invalid_names.join(', ')}"
      puts "#{blank_names.size} blank_names, they are #{blank_names.join(', ')}"

    end
  end
end
