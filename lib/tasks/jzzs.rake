desc "project net worth"
task :jzzs => [:environment] do
  number = 0
  number = Project.joins(:net_worths).last.id
  enddate = Time.now.strftime("%F")
  sb = SpiderBase.new

  Project.where.not(set_up_at: [nil, '']).where("id >= ?", number).find_each.with_index do |project, index|
  # Project.where.not(set_up_at: [nil, '']).where("id >= ?", number).order(id: :desc).each_with_index do |project, index|
    code = project.code
    startdate = project.set_up_at.strftime("%F")

    url = "http://jingzhi.funds.hexun.com/DataBase/jzzs.aspx?fundcode=#{code}&startdate=#{startdate}&enddate=#{enddate}"

    # project = Project.find_by(code: '110011')

    # doc = Nokogiri::HTML(open url);
    sb ||= SpiderBase.new

    fetch_content = sb.page_for_url(url);
    puts "Fetch project #{code} data from #{url} =========== #{index}"

    doc = fetch_content.doc;

    datas_ele = doc.css(".n_table.m_table tbody tr");

    datas_ele.each do |data_ele|
      _record_at, _dwjz, _ljjz, _accnav = data_ele.children.select{|x| x.name == "td"}

      if _record_at && _dwjz && _ljjz && _accnav
        record_at = _record_at.text
        dwjz = _dwjz.text
        ljjz = _ljjz.text
        accnav = _accnav.text.gsub(/%$/, '')

        data = project.net_worths.create(record_at: record_at,
          dwjz: dwjz,
          ljjz: ljjz,
          accnav: accnav)

        if Rails.env.development?
          post_data_to_server({
            net_worth: {
              record_at: record_at,
              dwjz: dwjz,
              ljjz: ljjz,
              accnav: accnav
            },
            project_code: project.code
          })
        end
      end
    end

    # iopv 日增长值, accnav 日增长率
    # dwjz 单位净值, ljjz 累计净值
  end
end

desc "store fund jz from set_up_at to today."
task :store_jzzs_to_dir => [:environment] do
  number = 0
  enddate = Time.now.strftime("%F")
  sb ||= SpiderBase.new

  Project.where.not(set_up_at: [nil, '']).where("id >= ?", number).find_each.with_index do |project, index|
    code = project.code
    startdate = project.set_up_at.strftime("%F")

    url = "http://jingzhi.funds.hexun.com/DataBase/jzzs.aspx?fundcode=#{code}&startdate=#{startdate}&enddate=#{enddate}"

    # project = Project.find_by(code: '110011')

    # doc = Nokogiri::HTML(open url);
    sb ||= SpiderBase.new

    fetch_content = sb.page_for_url(url);
    puts "Fetch project #{code} data from #{url} =========== #{index}"

    doc = fetch_content.doc;


    fund_dir = Rails.public_path.join("fund/hexun/jzzs")
    FileUtils::mkdir_p(fund_dir)

    file_name_with_path = fund_dir.join("#{project.code}.html")


    begin
      File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
    rescue Exception => e
      puts "=============Error #{project.code}, Exception #{e}"
      break
    end
  end
end

def post_data_to_server(params={}, headers={})
  headers ||= {:headers => {'Content-Type' => 'application/json',
    "Authorization" => "key",
    "Accept" => "application/json"},
    :cookies => {:_zhenkuan_session => Settings.production_cookies}
  }

  RestClient.post( "http://localhost:3000/net_worths", params, headers )
end
