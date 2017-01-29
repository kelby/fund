desc "Fetch eastmoney fund jbgk"
task :fetch_eastmoney_fund_jbgk => [:environment] do
  sb = SpiderBase.new

  number = Project.joins(:fund_jbgks).last.id

  # Project.limit(10).each_with_index do |project, index|
  Project.where("number > ?", number).find_each.each_with_index do |project, index|
    code = project.code

    sb ||= SpiderBase.new
    # code = 110051
    # index ||= 0
    # project ||= Project.find_by(code: code)

    url = "http://fund.eastmoney.com/f10/jbgk_#{code}.html"
    fetch_content = sb.page_for_url(url);
    puts "Fetch project #{code} data from #{url} =========== #{index}"

    doc = fetch_content.doc;

    table_ele = doc.css(".box table")


    jbgk = project.fund_jbgks.build


    table_ele.css("th").each do |th_ele|
      th_text = th_ele.text


      case th_text
      when "基金全称"
        jbgk.full_name = th_ele.next_element.text.try(:strip)
      when "基金简称"
        jbgk.short_name = th_ele.next_element.text
      when "基金代码"
        jbgk.code = th_ele.next_element.text
      when "基金类型"
        jbgk.mold = th_ele.next_element.text
      when "发行日期"
        jbgk.set_up_at = th_ele.next_element.text
      when "成立日期/规模"
        jbgk.build_at_and_scale = th_ele.next_element.text
      when "资产规模"
        jbgk.assets_scale = th_ele.next_element.text
      when "份额规模"
        jbgk.portion_scale = th_ele.next_element.text
      else
        # ...
        jbgk.others[th_text] = th_ele.next_element.text
      end



      # 基金全称
      # 基金简称
      # 基金代码
      # 基金类型
      # 发行日期
      # 成立日期/规模
      # 资产规模
      # 份额规模

      # FundJbgk.find_or_create_by(code: )
      # t.string :full_name
      # t.string :short_name
      # t.string :code
      # t.string :mold
      # t.string :set_up_at
      # t.string :build_at_and_scale
      # t.string :assets_scale
      # t.string :portion_scale
      # t.string :benchmark
      # t.text :dividend_policy
      # t.string :risk_yield
    end


    if jbgk.build_at_and_scale.present?
      set_up_at = jbgk.build_at_and_scale.split(" ").first.gsub(/年|月/, '-').gsub(/日/, "")

      if project.set_up_at.blank? && (set_up_at =~ /^\d/ && set_up_at =~ /\d$/)
        project.update(set_up_at: set_up_at)
      end
    end


    section_ele = doc.css("h4.t")

    section_ele.each do |h4_ele|
      h4_text = h4_ele.css("label.left").text

      case h4_text
      when "分红政策"
        jbgk.dividend_policy = h4_ele.next_element.next_element.text if h4_ele.next_element.next_element.name == "p"
      when "业绩比较基准"
        jbgk.benchmark = h4_ele.next_element.next_element.text.try(:strip) if h4_ele.next_element.next_element.name == "p"
      when "风险收益特征"
        jbgk.risk_yield = h4_ele.next_element.next_element.text.try(:strip) if h4_ele.next_element.next_element.name == "p"
      else
        # ...
      end
    end

    jbgk.save
  end
end