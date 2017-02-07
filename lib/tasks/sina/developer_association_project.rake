namespace :sina do
  # http://vip.stock.finance.sina.com.cn/fund_center/index.html#jjjlzz
  namespace :zz do
    desc "zai zhi manager association project. list"
    task :zz_developer_association_project => [:environment] do
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new

      num = 1000

      1.upto(6) do |page|
        url = "http://app.xincai.com/fund/api/jsonp.json/IO.XSRV2.CallbackList['K4bwNiJaR7YSKhGa']/XinCaiOtherService.getManagerFundInfo?page=#{page}&num=#{num}&sort=NavRate&asc=0&ccode=&date=&type2=1&%5Bobject%20HTMLDivElement%5D=xeemg"

        # 获取
        browser.goto url


        association_project_dir = Rails.public_path.join("manager/sina/association_project/zz")
        FileUtils::mkdir_p(association_project_dir)

        file_name_with_path = association_project_dir.join("#{page}.html")

        begin
          File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
        rescue Exception => e
          puts "=============Error #{e}"
        end
      end
    end

    desc "fetch association data from html dir file."
    task :fetch_association_data => [:environment] do
      1.upto(6) do |page|
        association_project_dir = Rails.public_path.join("manager/sina/association_project/zz")
        file_name_with_path = association_project_dir.join("#{page}.html")

        doc = Nokogiri::HTML(open(file_name_with_path).read);


        body_text = doc.css("body").text;
        dup_body_text = body_text;


        # regexp = /\{start_grab_entries\}(.*?)\{end_grab_entries\}/m
        # {FundCompanyId:"80199117",FundCompanyName:"华润元大基金管理有限公司",FundNum_OF:15,FundShare_Open:"23.36",FundNum_CF:0,FundShare_Close:"--",FundNum_Total:15,FundShare_Total:"23.36"}

        valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0];
        json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "");

        # 危险操作，请先大致查看页面内容，确认是安全的！
        # 页面内容奇怪，不能直接使用 JSON.parse
        result_hash = eval(json_str.as_json);
        result_hash.keys

        association_array = result_hash[:data];
        association_array.size
        # [:Name, 姓名
        # :ManagerId,
        # :RHDate, 任职日期
        # :Symbol, 基金代码
        # :ShortName, 基金简称
        # :BDate, 开始时间
        # :EDate, 结束时间
        # :NavRate, 任期回报率(%)
        # :HYNavRate, 同类平均回报(%)
        # :Rank, 任期回报排名
        # :AllNum] 同类经理数量

        association_array.each do |cd_association|
          catalog_developers = DeveloperProject.joins(:catalog, :developer).where(catalogs: {code: cd_association[:Symbol]}).where(developers: {name: cd_association[:Name]});

          if catalog_developers.present?
            next
          end

          developers = Developer.where(name: cd_association[:Name]);

          if developers.blank?
            next
          end

          if developers.many?
            next
          end

          catalog = Catalog.find_by(code: cd_association[:Symbol]);

          if catalog_developers.blank? && developers.one? && catalog.present?
            developer = developers.first
            # ...
            CatalogDeveloper.create(catalog_id: catalog.id, developer_id: developer.id)
          end
        end
      end
    end

    desc "set confirm manager sina_code"
    task :set_confirm_manager_sina_code => [:environment] do
      problem_names = []
      dup_names = []
      blank_names = []

      1.upto(6) do |page|
        puts "process page #{page} data ==================="
        association_project_dir = Rails.public_path.join("manager/sina/association_project/zz")
        file_name_with_path = association_project_dir.join("#{page}.html")

        doc = Nokogiri::HTML(open(file_name_with_path).read);


        body_text = doc.css("body").text;
        dup_body_text = body_text;


        # regexp = /\{start_grab_entries\}(.*?)\{end_grab_entries\}/m
        # {FundCompanyId:"80199117",FundCompanyName:"华润元大基金管理有限公司",FundNum_OF:15,FundShare_Open:"23.36",FundNum_CF:0,FundShare_Close:"--",FundNum_Total:15,FundShare_Total:"23.36"}

        valid_content = dup_body_text.scan(/\(\(.*?\)\)/)[0];
        json_str = valid_content.gsub(/^\(\(/, "").gsub(/\)\)$/, "");

        # 危险操作，请先大致查看页面内容，确认是安全的！
        # 页面内容奇怪，不能直接使用 JSON.parse
        json_str = json_str.gsub(/:null/, ":'null'") # 原字符串里有 null 关键字
        result_hash = eval(json_str.as_json);
        result_hash.keys

        association_array = result_hash[:data];
        association_array.size

        # [:Name, 姓名
        # :ManagerId,
        # :RHDate, 任职日期
        # :Symbol, 基金代码
        # :ShortName, 基金简称
        # :BDate, 开始时间
        # :EDate, 结束时间
        # :NavRate, 任期回报率(%)
        # :HYNavRate, 同类平均回报(%)
        # :Rank, 任期回报排名
        # :AllNum] 同类经理数量

        association_array.each do |cd_association|
          name = cd_association[:Name]
          developers = Developer.where(name: name)

          if developers.one?
            developer = developers.first

            if developer.sina_code.blank?
              developer.update_columns(sina_code: cd_association[:ManagerId])
            elsif developer.sina_code == cd_association[:ManagerId]
              # ...
            else
              problem_names << name
            end
          elsif developers.blank?
            blank_names << name
          else
            dup_names << name
          end
          # ...
        end
      end

      if problem_names.present?
        puts "#{problem_names.size} problem_names\n"
        puts problem_names.join(', ')
      end

      if blank_names.present?
        puts "#{blank_names.size} blank_names\n"
        puts blank_names.join(', ')
      end

      if dup_names.present?
        puts "#{dup_names.size} dup_names\n"
        puts dup_names.join(', ')
      end
    end
  end


  # http://vip.stock.finance.sina.com.cn/fund_center/index.html#jjjllz
  namespace :lz do
    desc "li zhi manager association project. list"
    task :lz_developer_association_project => [:environment] do
      headless = Headless.new
      headless.start
      browser = Watir::Browser.new


      num = 1000

      1.upto(5) do |page|
        url = "http://app.xincai.com/fund/api/jsonp.json/IO.XSRV2.CallbackList['ntERghbCNLn4ixRQ']/XinCaiOtherService.getManagerFundInfo?page=#{page}&num=#{num}&sort=NavRate&asc=0&ccode=&date=&type2=0&%5Bobject%20HTMLDivElement%5D=77gza"

        # 获取
        browser.goto url


        association_project_dir = Rails.public_path.join("manager/sina/association_project/lz")
        FileUtils::mkdir_p(association_project_dir)

        file_name_with_path = association_project_dir.join("#{page}.html")

        begin
          File.open(file_name_with_path, 'w') { |file| file.write(browser.html) }
        rescue Exception => e
          puts "=============Error #{e}"
        end
      end
    end
  end
end
