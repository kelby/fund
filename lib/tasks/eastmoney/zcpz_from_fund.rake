namespace :eastmoney do
  desc "zcpz list from a fund"
  task :zcpz_from_fund => [:environment] do
    sb ||= SpiderBase.new
    number = 0

    no_found_projects = []

    # Project.limit(3).each_with_index do |project, index|
    Project.where("id > ?", number).find_each.each_with_index do |project, index|
      code = project.code

      sb ||= SpiderBase.new


      url = "http://fund.eastmoney.com/f10/zcpz_#{code}.html"
      fetch_content = sb.page_for_url(url);
      puts "Fetch project #{code} data from #{url} =========== #{index}"

      doc = fetch_content.doc;


      fund_zcpz_dir = Rails.public_path.join("fund/eastmoney/zcpz")
      FileUtils::mkdir_p(fund_zcpz_dir)

      file_name_with_path = fund_zcpz_dir.join("#{code}.html")

      if doc.css(".detail").blank?
        no_found_projects << "#{code}--#{project.name}"
        puts "=============Not Found #{project.id} #{code}"
        next
      end

      begin
        File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{project.id} #{code}"
      end
    end

    puts "以下 #{no_found_projects.size} 没有找到对应的资产配置页面\n"
    puts no_found_projects.join(', ')
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    # sb ||= SpiderBase.new
    number = 0

    Project.where("id > ?", number).find_each.each_with_index do |project, index|
      code = project.code

      fund_zcpz_dir = Rails.public_path.join("fund/eastmoney/zcpz")

      file_name_with_path = fund_zcpz_dir.join("#{code}.html")

      unless File.exists?(file_name_with_path)
        next
      end

      # fetch_content = sb.page_for_url(file_name_with_path);
      # doc = fetch_content.doc;
      doc = Nokogiri::HTML(open(file_name_with_path).read);

      table_ele = doc.css("table.tzxq")

      if table_ele.present?
        head_text = table_ele.css("thead").text.strip

        if head_text =~ /报告期/ && head_text =~ /股票/ && head_text =~ /债券/ && head_text =~ /现金/ && head_text =~ /净资产/
          table_ele.css("tbody tr").each do |tr_ele|
            aa = tr_ele.css("td")[0]
            bb = tr_ele.css("td")[1]
            cc = tr_ele.css("td")[2]
            dd = tr_ele.css("td")[3]
            ee = tr_ele.css("td")[4]

            record_at = aa.text
            stock_ratio = bb.text.strip.to_f
            bond_ratio = cc.text.strip.to_f
            cash_ratio = dd.text.strip.to_f
            net_asset = ee.text.strip.to_f

            # puts "fund #{code} === #{record_at}, #{stock_ratio}, #{bond_ratio}, #{cash_ratio}, #{net_asset}"

            stock_ratio = nil if stock_ratio.zero?
            bond_ratio = nil if bond_ratio.zero?
            cash_ratio = nil if cash_ratio.zero?

            project.asset_allocations.create(record_at: record_at,
              stock_ratio: stock_ratio,
              bond_ratio: bond_ratio,
              cash_ratio: cash_ratio,
              net_asset: net_asset)
          end
        end
      end
    end

  end
end