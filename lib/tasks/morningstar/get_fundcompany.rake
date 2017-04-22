namespace :morningstar do
  desc "Task description"
  task :get_fundcompany => [:environment] do
    # ...
  end

  namespace :get do
    def browser
      headless ||= Headless.new
      headless.start

      mkdir_fundcompany

      @browser ||= Watir::Browser.new
    end

    def url
      "http://cn.morningstar.com/fundcompany/default.aspx"
    end

    def fundcompany_dir
      Rails.public_path.join("fund/morningstar/fundcompany/")
    end

    def mkdir_fundcompany
      FileUtils::mkdir_p(fundcompany_dir)
    end

    # 快照
    desc "fundcompany_snapshots"
    task :fundcompany_snapshots => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text
      file_name_with_path = fundcompany_dir.join("fundcompany_snapshots.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_snapshots Exception #{e}"
      end
    end

    # 基金经理
    desc "fundcompany_managers"
    task :fundcompany_managers => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbManager").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_managers.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_managers Exception #{e}"
      end
    end

    # 星级分布
    desc "fundcompany_stars"
    task :fundcompany_stars => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbStar").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_stars.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_stars Exception #{e}"
      end
    end

    # 最佳业绩
    desc "fundcompany_best_returns"
    task :fundcompany_best_returns => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbBestReturn").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_best_returns.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_best_returns Exception #{e}"
      end
    end

    # 业绩分布
    desc "fundcompany_performances"
    task :fundcompany_performances => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbPerformance").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_performances.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_performances Exception #{e}"
      end
    end

    # 资产分布
    desc "fundcompany_assets"
    task :fundcompany_assets => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbAssets").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_assets.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_assets Exception #{e}"
      end
    end

    # 基本信息
    desc "fundcompany_infos"
    task :fundcompany_infos => [:environment] do
      browser.goto url

      browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      browser.a(id: "ctl00_cphMain_lbOperations").click
      puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      file_name_with_path = fundcompany_dir.join("fundcompany_infos.html")

      begin
        File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      rescue Exception => e
        puts "============= fundcompany_infos Exception #{e}"
      end
    end

    desc "fundcompanies"
    task :fundcompanies => [:environment] do
      # browser.goto url

      # browser.cookies.add 'authWeb', "B44D0CE66A8CF5BC0C9FB477D5456F95E473BD0B2659FC420D9E67F456079A56CB14BAF43D12DF88A81223DE0AF8E7D92413A5E1802E9C49CEDF0C222C0ABCF246E4F085161936E5F4F3CF372DB858376506790627EB21FC0E706163526098BC9AD26B270162B9B8DEE509166848E544AEDED8C2"

      # browser.a(id: "ctl00_cphMain_lbPerformance").click
      # puts browser.table(id: "ctl00_cphMain_gridResult").tr(class: "header").text

      # file_name_with_path = fundcompany_dir.join("fundcompany_performances.html")

      # begin
      #   File.open(file_name_with_path, 'w:UTF-8') { |file| file.write(browser.html) }
      # rescue Exception => e
      #   puts "============= fundcompany_performances Exception #{e}"
      # end
    end
  end
end
