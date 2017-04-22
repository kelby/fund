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
      end
    end

    # 最佳业绩
    desc "fundcompany_best_returns"
    task :fundcompany_best_returns => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_best_returns.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
      end
    end

    # 业绩分布
    desc "fundcompany_performances"
    task :fundcompany_performances => [:environment] do
      file_name_with_path = fundcompany_dir.join("fundcompany_performances.html")
      
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      puts doc.css("table#ctl00_cphMain_gridResult tr.header").text

      doc.css("tr.gridAlternateItem, tr.gridItem").each do |x|
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
      # ...
    end
  end
end
