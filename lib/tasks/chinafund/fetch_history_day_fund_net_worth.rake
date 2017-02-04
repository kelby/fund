namespace :chinafund do
  desc "Task description"
  task :fetch_history_day_fund_net_worth => [:environment] do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.new

    url = "http://data.chinafund.cn/kf/20170126.html"
    browser.goto url

    table_ele = browser.table(id: "tablesorter")

    table_ele.thead.tr.text

    table_ele.tbody.trs[0].text
    table_ele.tbody.trs.size

    trs_ele = table_ele.tbody.trs

    trs_ele.each do |tr_ele|
      tds = tr_ele.tds

      # 关注  日期  代码  简称  分类  净值  累计净值  日增值 日增长%  周增% 月增% 季增% 半年增%  年增% 代销|购买|赎回  相关
      code_ele = tds[2]
      dwjz_ele = tds[5]
      ljjz_ele = tds[6]
      # iopv_ele = tds[7]
      accnav_ele = tds[8]

      code = code_ele.text
      dwjz = dwjz_ele.text
      ljjz = ljjz_ele.text
      _accnav = accnav_ele.text

      if dwjz.blank? || ljjz.blank? || _accnav.blank?
        next
      end

      if dwjz =~ /\d+/ || ljjz =~ /\d+/ || _accnav =~ /\d+/
        accnav = _accnav.to_f.round(2)

        if ((ljjz.to_f - dwjz.to_f) > 0) && accnav.zero?
          next
        else
          project = Project.find_by(code: code)

          if project.blank?
            next
          else
            project.net_worths.create(dwjz: dwjz, ljjz: ljjz, accnav: accnav, record_at: '2017-01-26')
          end
        end
      else
        next
      end
    end

  end
end