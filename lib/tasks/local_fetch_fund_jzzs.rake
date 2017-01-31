require 'nokogiri'
require 'open-uri'

namespace :local do
  desc "fetch fund jbgk, for kinsfolk."
  task :fetch_fund_jbgk => [:environment] do

    jzzs_dir = Rails.public_path.join("fund/hexun/jzzs")

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

  end
end
