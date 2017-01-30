require 'nokogiri'
require 'open-uri'

namespace :local do
  desc "fetch fund jbgk, for kinsfolk."
  task :fetch_fund_jbgk => [:dependent, :tasks] do

    jbgk_dir = Rails.public_path.join("fund/eastmoney/jbgk")

    Dir.entries(jbgk_dir).each_with_index do |file_name, index|
      file_path = jbgk_dir.join(file_name)

      doc = Nokogiri::HTML(open(file_path));

      valid_box = doc.css(".box").select{|x| x.css("h4").text =~ /基金分级信息/ }.first

      if valid_box.blank?
        next
      else
        # ...
        valid_th_ele = valid_box.css("th").select{|x| x.text =~ /母子基金/ }.first

        if valid_th_ele.blank?
          next
        else
          # ...
          valid_td_ele = valid_th_ele.next_element

          if valid_td_ele.name == "td"
            codes = valid_td_ele.text.split(/（|）|\s/).select{|x| x =~ /^\d+$/ }

            main_code = codes.shift
            other_codes = codes


            project = Project.find_by(code: main_code)
            projects = Project.where(code: other_codes)

            if project.present? && projects.present?
              puts "set Kinsfolk for mother #{project.code}, son #{projects.pluck(:code).join(',')}"
            end

            project.mother!
            projects.map(&:son!)

            projects.ids.each do |son_id|
              Kinsfolk.create(mother_id: project.id, son_id: son_id)
            end
          end
        end
      end
    end

  end
end