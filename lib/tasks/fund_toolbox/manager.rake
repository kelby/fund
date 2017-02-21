namespace :manager do
  desc "developer has projects, but no catalogs."
  task :set_catalog_from_projects => [:environment] do
    Developer.includes(:catalogs, :projects).find_each do |developer|
      if developer.catalogs.blank? && developer.projects.present?
        developer.projects.pluck(:catalog_id).each do |catalog_id|
          CatalogDeveloper.create(catalog_id: catalog_id, developer_id: developer.id)
        end
      end
    end
  end

  # desc "developer has catalogs, but no projects."
  # task :task_name => [:dependent, :tasks] do
  #   Developer.find_each do |developer|
  #     if developer.catalogs.present? && developer.projects.blank?
  #       # ...
  #     end
  #   end
  # end
  desc "set catalog cover and description from sina_info."
  task :set_cover_and_description_from_sina_info => [:environment] do
    Catalog.joins(:catalog_sina_info).each do |catalog|
      catalog.remote_cover_url = catalog.catalog_sina_info.header_info['cover']
      catalog.description = catalog.catalog_sina_info.table_info['公司简介']

      if catalog.changed?
        catalog.save
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    Developer.where.not(description: [nil, ""]).find_each.with_index do |developer, index|
      developer.description = developer.description.strip.gsub(/^基金经理简介：/, "")

      if developer.description_changed?
        developer.save
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    DeveloperProject.where(end_of_work_date: nil).includes(:developer, :project).find_each do |dp|
      project = dp.project

      if project.blank? || project.set_up_at.blank?
        puts "基金 #{project.code} 存在问题 ============="
        next
      end

      if dp.term_of_office.blank? && dp.as_return.blank?
        dp.destroy

        puts "删除 #{project.code} 基金经理 #{dp.developer.name} 就职经历, #{dp.beginning_work_date}"
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    Project.where(mold: [nil, ""]).includes(:fund_jbgks).joins(:fund_jbgk).distinct.each do |project|
      mold = project.fund_jbgk.mold

      if mold.blank?
        next
      else
        puts "project mold should be #{mold}"
        project.mold = mold
        project.tag_list.add(mold)

        project.save
      end
    end
  end

  desc "Task description"
  task :task_name => [:dependent, :tasks] do
    jbgk_dir = Rails.public_path.join("fund/eastmoney/jbgk")


    Project.includes(:fund_jbgk).where(fund_jbgks: {project_id: nil}).each do |project|

      file_name_with_path = jbgk_dir.join("#{project.code}.html")

      unless File.exists?(file_name_with_path)
        next
      end

      doc = Nokogiri::HTML(open(file_name_with_path).read);



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
      project.save
    end
  end
end