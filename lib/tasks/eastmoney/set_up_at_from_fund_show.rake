namespace :eastmoney do
  desc "if project set_up_at is nil, try to set it."
  task :set_up_at_from_fund_show => [:environment] do
    fund_show_dir = Rails.public_path.join("fund/eastmoney/show")

    Project.where(set_up_at: [nil, ""]).count

    Project.where(set_up_at: [nil, ""]).find_each do |project|
      code = project.code
      file_name_with_path = fund_show_dir.join("#{code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);

      info_ele = doc.css(".infoOfFund")

      info_ele.css("table tr td").each do |td_ele|
        td_text = td_ele.text

        if td_text =~ /成 立 日/
          time_ele = td_ele.children.last

          project.set_up_at = time_ele.text.to_time

          if project.changed?
            project.save
          end

          # break
          time_ele = nil
        else
          next
        end

        td_text = nil
      end

      info_ele = nil
    end

    Project.where(set_up_at: [nil, ""]).count
  end
end
