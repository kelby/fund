namespace :tenbagger do
  desc "select tenbagger funds from eastmoney funds show page data."
  task :select_tenbagger_funds => [:environment] do
    projects = Project.where("set_up_at <= ?", 10.years.ago);
    valid_projects = []

    # projects
    fund_show_dir = Rails.public_path.join("fund/eastmoney/show")

    projects.each do |project|
      code = project.code

      # url = "http://fund.eastmoney.com/#{code}.html"
      # fetch_content = sb.page_for_url(url);
      # puts "Fetch project #{code} data from #{url} =========== #{index}"

      # doc = fetch_content.doc;


      file_name_with_path = fund_show_dir.join("#{code}.html")

      doc = Nokogiri::HTML(open(file_name_with_path).read);




      info_ele = doc.css(".dataOfFund");

      info_ele.css("dl dd").each do |dd_ele|
        dd_text = dd_ele.text

        if dd_text =~ /成立来/
          get_rate = dd_ele.css(".ui-num")

          get_rate_to_number = get_rate.text.to_f

          if get_rate_to_number >= 999
            valid_projects << "#{code}-#{project.name}-#{get_rate_to_number}"
          end

          # break
          get_rate = nil
        else
          next
        end

        dd_text = nil
      end
    end

    puts valid_projects.size
    puts valid_projects.join(', ')
  end
end
