namespace :chinafund do
  
  desc "Task description"
  task :fetch_day_fund_net_worth => [:environment] do
    sb = SpiderBase.new

    url = "http://www.chinafund.cn/article/201723/201723_330821.html"


    fetch_content = sb.page_for_url(url);
    # puts "Fetch index_report #{catalog} data from #{url} =========== #{index}"

    doc = fetch_content.doc;

    date_ele = doc.css("#title")

    record_at = date_ele.text.split("净值").last

    if record_at.blank?
      raise "Date #{record_at} An error has occured"
    end

    table_ele = doc.css("#news_text table");
    table_ele.css("tr").size

    table_ele.css("tr").each do |tr_ele|
      tr_text = tr_ele.text

      if tr_text =~ /代码/ && tr_text =~ /简称/
        next
      else
        code_ele, name_ele, dwjz_ele, ljjz_ele, accnav_ele = tr_ele.css("td")

        code = code_ele.text
        dwjz = dwjz_ele.text
        ljjz = ljjz_ele.text
        accnav = accnav_ele.text

        project = Project.find_by(code: code)

        if project.blank?
          next
        end

        if (dwjz.present? && ljjz.present?) && (dwjz =~ /\d+/ && ljjz =~ /\d+/)
          net_worth = project.net_worths.build(dwjz: dwjz, ljjz: ljjz, record_at: record_at, accnav: accnav)

          if net_worth.save
            # ...
          elsif net_worth.errors.details[:record_at].inspect =~ /:taken/
            # ...
            old_net_worth = net_worth.project.net_worths.where(record_at: record_at).last
            old_net_worth.update(accnav: accnav)
          end
        else
          next
        end
      end
    end

  end
  
end