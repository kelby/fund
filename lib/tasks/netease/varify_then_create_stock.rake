desc "Task description"
task :task_name => [:environment] do
  invalid_stock = []

  IndexReport.find_each.with_index do |index_report, index|
  # IndexReport.limit(50).each_with_index do |index_report, index|
    index ||= 0
    code = index_report.code
    # _code = '0' + code
    name = index_report.name



    if code.blank?
      next
    end

    sb ||= SpiderBase.new



    url = "http://quote.eastmoney.com/zs#{code}.html"
    # url = "http://quotes.money.163.com/#{_code}.html"

    fetch_content = sb.page_for_url(url);

    puts "varify stoce #{code} from netease, url #{url} ========= #{index}"
    doc = fetch_content.doc;

    if doc.css(".qphox .header-title-c.fl").text.blank?
      puts "don't find stock #{code}"
      invalid_stock << "#{code}-#{name}"
      next
    end


    @stock_dir ||= Rails.public_path.join("stock/eastmoney/show")
    FileUtils::mkdir_p(@stock_dir)


    file_name_with_path = @stock_dir.join("#{code}.html")


    begin
      File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
    rescue Exception => e
      puts "=============Error #{code}"
    end

    stock = Stock.create(name: name, code: code)

    # if stock.persisted?
    #   quote.stock_id = stock.id
    #   quote.save
    # end
  end

  puts "invalid #{invalid_stock.size} stocks, they are: #{invalid_stock.join(', ')}"

end
