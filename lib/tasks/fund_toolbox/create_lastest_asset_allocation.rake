namespace :fund_toolbox do
  desc "Task description"
  task :create_lastest_asset_allocation => [:environment] do
    fund_show_dir = Rails.public_path.join("fund/eastmoney/show")

    Project.includes(:asset_allocations).where(asset_allocations: {project_id: nil}).each do |project|

      # ...

      code = project.code
      file_name_with_path = fund_show_dir.join("#{code}.html")

      if File.exists?(file_name_with_path)
        doc = Nokogiri::HTML(open(file_name_with_path).read);

        tds_ele = doc.css(".fundInfoItem .infoOfFund td")

        if tds_ele.present?
          target_td_ele = tds_ele.select{|x| x.text =~ /基金规模/}[0]

          if target_td_ele.present?
            ele_text = target_td_ele.text.strip

            net_asset = ele_text.scan(/\d{1,99}.*亿元/)[0]
            record_at = ele_text.scan(/\d{4}-\d{2}-\d{2}/)[0]
            origin = 'fund_show_page'

            project.asset_allocations.create(net_asset: net_asset, record_at: record_at, origin: origin)
          end
        end
      end

    end
  end
end
