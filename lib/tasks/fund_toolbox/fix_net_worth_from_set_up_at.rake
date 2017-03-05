namespace :fund_toolbox do
  desc "Task description"
  task :fix_net_worth_from_set_up_at => [:dependent, :tasks] do
    # ...
    record_at_gt_set_up_at = []
    project_codes = []

    Project.where.not(set_up_at: nil).joins(:net_worths).distinct.find_each.with_index do |project, index|
      first_net_worth = project.net_worths.asc.first

      if first_net_worth.record_at > project.set_up_at
        record_at_gt_set_up_at << "#{project.code}-#{first_net_worth.record_at}-#{project.set_up_at}"

        if (first_net_worth.record_at - project.set_up_at) > 7.day
          project_codes << project.code
        end
      end
    end

    puts "record_at_gt_set_up_at size #{record_at_gt_set_up_at.size}\n"
    puts record_at_gt_set_up_at.join(", ")
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    number = 0
    # number = Project.joins(:net_worths).last.id
    enddate = Time.now.strftime("%F")
    sb = SpiderBase.new

    project_codes = []
    Project.where.not(set_up_at: nil).joins(:net_worths).distinct.find_each.with_index do |project, index|
      first_net_worth = project.net_worths.asc.first

      if first_net_worth.record_at > project.set_up_at
        if (first_net_worth.record_at - project.set_up_at) > 7.day
          project_codes << project.code
        end
      end
    end

    Project.where(code: project_codes).where.not(set_up_at: [nil, '']).where("id >= ?", number).find_each.with_index do |project, index|
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
end