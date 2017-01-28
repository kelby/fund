desc "project net worth"
task :jzzs => [:environment] do
  number = 0
  number = Project.joins(:net_worths).last.id
  enddate = Time.now.strftime("%F")

  Project.where.not(set_up_at: [nil, '']).where("id >= ?", number).find_each.with_index do |project, index|
  # Project.where.not(set_up_at: [nil, '']).where("id >= ?", number).order(id: :desc).each_with_index do |project, index|
    code = project.code
    startdate = project.set_up_at.strftime("%F")

    url = "http://jingzhi.funds.hexun.com/DataBase/jzzs.aspx?fundcode=#{code}&startdate=#{startdate}&enddate=#{enddate}"

    # project = Project.find_by(code: '110011')

    # doc = Nokogiri::HTML(open url);
    sb = SpiderBase.new

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
            :project_code: project.code
          })
        end
      end
    end

    # iopv 日增长值, accnav 日增长率
    # dwjz 单位净值, ljjz 累计净值
  end
end

def post_data_to_server(params={}, headers={})
  headers ||= {:headers => {'Content-Type' => 'application/json',
    "Authorization" => "key",
    "Accept" => "application/json"}
    :cookies => {:_zhenkuan_session => Settings.cookies}
  }

  RestClient.post( "http://localhost:3000/net_worths", params, headers )
end
