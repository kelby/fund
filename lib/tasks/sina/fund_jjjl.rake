namespace :sina do
  desc "Task description"
  task :fund_jjjl => [:dependent, :tasks] do
    projects = Project.includes(:developer_projects).where(developer_projects: {project_id: nil});
    sb ||= SpiderBase.new
    manager_dir = Rails.public_path.join("manager/sina/show_info")


    projects.each do |project|
      code = project.code
      url = "http://finance.sina.com.cn/fund/quotes/#{code}/bc.shtml"

      fetch_content = sb.page_for_url(url);

      doc = fetch_content.doc;

      fund_jjjl_ele = doc.css(".fund_jjjl")

      if fund_jjjl_ele.present?
        managers_info = fund_jjjl_ele.css("a").map{|x| [x.text, x.attr('href')] }

        sina_codes = managers_info.map { |e| e.last.scan(/mid=\d{1,99}/)[0].scan(/\d{1,99}$/)[0] }

        # name, sina_code, manager_show_url
        format_managers_info = managers_info.map { |e| [e.first, e.last.scan(/mid=\d{1,99}/)[0].scan(/\d{1,99}$/)[0], e.last] }

        format_managers_info.each_with_index do |x, index|
          name, sina_code, manager_show_url = x
          manager = Developer.find_by(sina_code: sina_code)

          if manager.present?
            # manager_show_url = "http://stock.finance.sina.com.cn/manager/view/mInfo.php?mid=#{sina_code}"
            fetch_content = sb.page_for_url(manager_show_url);
            doc = fetch_content.doc;

            h3_ele = doc.css("h3.tit").select{|x| x.text =~ /历史业绩/}[0]

            if h3_ele.present?
              table_ele = h3_ele.next_element.next_element

              if table_ele.name == "table"
                trs_ele = table_ele.css("tr")

                trs_ele.each do |tr_ele|
                  tr_text = tr_ele.text

                  if tr_text =~ /产品名称/ && tr_text =~ /任职公司/
                    next
                  else
                    # developer_id = 
                    # DeveloperProject.create()
                    # 产品名称  任职公司  管理类型  任职时间  任期回报  同类平均  行业排名  操作
                    project_name = tr_ele.css("td")[0]
                    company_name = tr_ele.css("td")[1]
                    # tr_ele.css("td")[2]
                    appointment_range = tr_ele.css("td")[3]
                    # tr_ele.css("td")[4]
                    # tr_ele.css("td")[5]
                    # tr_ele.css("td")[6]
                    # tr_ele.css("td")[7]

                    project_code = project_name.css('a').attr('href').value.scan(/quotes\/\d{1,99}\/bc/)[0].split('/')[1]

                    DeveloperProject.create(developer_id: manager.id,
                      project_code: project_code,
                      # project_id: Project.find_by(code: project_code).id,
                      beginning_work_date: appointment_range.text.split('-').map(&:to_time).first,
                      end_of_work_date: appointment_range.text.split('-').map(&:to_time).last)
                  end
                end
              end
            end
          else
            developer = Developer.create(name: name, sina_code: sina_code)
            developer.catalog_id = project.catalog_id
            developer.save
          end
        end
      end
    end

  end
end
