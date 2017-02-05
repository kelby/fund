require 'nokogiri'
require 'open-uri'

namespace :local do
  desc "fetch fund jbgk, for kinsfolk."
  task :fetch_fund_jbgk => [:environment] do

    jzzs_dir = Rails.public_path.join("fund/hexun/jzzs")

    blank_net_worth_projects = []

    # 有条件的从本地更新部分数据
    # Project.where.not(set_up_at: [nil, ""]).includes(:net_worths).where(net_worths: {project_id: nil}).distinct.find_each.with_index do |project, index|
      # file_name = project.code + ".html"
    Dir.entries(jzzs_dir).each_with_index do |file_name, index|
      file_path = jzzs_dir.join(file_name)

      if file_name.to_s =~ /^\d/
        code = file_name.split(".").first

        project = Project.find_by(code: code)
      else
        next
      end

      doc = Nokogiri::HTML(open(file_path).read);

      puts "set net_worths project #{project.code} ========= #{index}"

      datas_ele = doc.css(".n_table.m_table tbody tr");

      if datas_ele.blank?
        blank_net_worth_projects << "#{project.code}--#{project.name}"
        next
      end

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
        end
      end
    end

    puts "以下 #{blank_net_worth_projects.size} 基金没有数据，是因为抓取有误吗？\n"
    puts blank_net_worth_projects.join(', ')

    # blank_net_worth_projects.map{|x| x.split("--").first }
  end
end
