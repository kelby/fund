desc "Fetch eastmoney fund jbgk"
task :fetch_eastmoney_fund_jbgk => [:environment] do
  sb = SpiderBase.new

  number ||= 0
  fund_show_dir = Rails.public_path.join("fund/eastmoney/show")
  FileUtils::mkdir_p(fund_show_dir)

  Project.where("id >= ?", number).find_each.each_with_index do |project, index|
    code = project.code

    url = "http://fund.eastmoney.com/#{code}.html"
    fetch_content = sb.page_for_url(url);
    puts "Fetch project #{code} data from #{url} =========== #{index}"

    doc = fetch_content.doc;


    file_name_with_path = fund_show_dir.join("#{code}.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
    rescue Exception => e
      puts "============= Project #{project.id}-#{project.code}, Exception #{e}"
    end
  end
end
