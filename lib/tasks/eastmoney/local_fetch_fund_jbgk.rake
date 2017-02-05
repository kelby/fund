require 'nokogiri'
require 'open-uri'

namespace :local do
  desc "fetch fund jbgk, for kinsfolk."
  task :fetch_fund_jbgk => [:environment] do

    jbgk_dir = Rails.public_path.join("fund/eastmoney/jbgk")

    Dir.entries(jbgk_dir).each_with_index do |file_name, index|
      unless file_name =~ /html/
        next
      end

      file_path = jbgk_dir.join(file_name)

      doc = Nokogiri::HTML(open(file_path).read);

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

  desc "detect and set fund mold"
  task :detect_and_set_fund_mold => [:environment] do
    jbgk_dir = Rails.public_path.join("fund/eastmoney/jbgk")

    Dir.entries(jbgk_dir).each_with_index do |file_name, index|
      unless file_name =~ /html/
        next
      end

      code = file_name.split(".").first
      project = Project.find_by(code: code)

      file_path = jbgk_dir.join(file_name)

      doc = Nokogiri::HTML(open(file_path).read);

      valid_box = doc.css("table.info")

      if valid_box.blank?
        next
      else
        valid_th_ele = valid_box.css("tbody tr th").select{|ele| ele.text == /基金类型/ }

        if valid_th_ele.blank?
          next
        end

        td_ele = valid_th_ele.next_element
        td_text = td_ele.text

        if project.mold.blank?
          project.mold = td_text
        elsif project.mold == td_text
          # ...
        else
          project.mold += ", #{td_text}"
        end

        if project.mold_changed?
          project.save
        end
      end
    end
  end
end