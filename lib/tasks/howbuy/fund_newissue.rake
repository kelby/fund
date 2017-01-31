namespace :howbuy do
  desc "Task description"
  task :fetch_howbuy_fund_newissue => [:environment] do
    url = "http://www.howbuy.com/fund/newissue/"

    sb ||= SpiderBase.new
    fetch_content = sb.page_for_url(url);

    doc = fetch_content.doc;


    fund_list_eles = doc.css("#tableData tr");

    fund_list_eles.each do |fund_item_ele|
      # 序号
      aa = fund_item_ele.css("td")[0]
      # 基金代码
      bb = fund_item_ele.css("td")[1]
      # 基金简称
      cc = fund_item_ele.css("td")[2]
      # 基金类型
      dd = fund_item_ele.css("td")[3]
      # 募集起始日
      ee = fund_item_ele.css("td")[4]
      # 募集终止日
      ff = fund_item_ele.css("td")[5]
      # 最高认购费率
      gg = fund_item_ele.css("td")[6]
      # 实际募集份额（亿）
      hh = fund_item_ele.css("td")[7]
      # 基金经理
      ii = fund_item_ele.css("td")[8]
      # 基金公司
      jj = fund_item_ele.css("td")[9]

      code = bb.css("a").text
      fund_name = cc.css("a").text

      beginning_at = ee.text
      endding_at = ff.text

      manager_name = ii.css("a").map(&:text)
      company_name = jj.css("a").text

      project = Project.find_by(code: code)
      if project.present?
        project.release_now!
        project.create_fund_raise(beginning_at: beginning_at, endding_at: endding_at)
      else
        # ...
        catalog_ids = Catalog.where("name LIKE ? OR short_name LIKE ?", company_name, company_name).ids
        developer_ids = Developer.where(name: manager_name).ids

        cds = CatalogDeveloper.where(catalog_id: catalog_ids, developer_id: developer_ids)

        if cds.one? || cds.pluck(:catalog_id).uniq.one?
          cds.each do |cd|
            cd = cds.first
            catalog = cd.catalog
            developer = cd.developer
          end

          pust "以下部分尚未完成...fund #{code}, manage #{manager_name.join(',')}, company #{company_name}"

          # project = Project.create(code: code, name: fund_name, catalog_id: catalog.id)
          # project.release_now!
          # project.create_fund_raise(beginning_at: beginning_at, endding_at: endding_at)
        end
      end
    end
  end

  desc "save howbuy fund newissue to dir"
  task :save_newissue_to_dir => [:environment] do
    url = "http://www.howbuy.com/fund/newissue/"

    sb ||= SpiderBase.new
    fetch_content = sb.page_for_url(url);

    doc = fetch_content.doc;


    newissue_dir = Rails.public_path.join("fund/howbuy/newissue")
    FileUtils::mkdir_p(newissue_dir)

    file_name_with_path = newissue_dir.join("list.html")

    begin
      File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }
    rescue Exception => e
      puts "=============Error #{e}"
    end
  end
end
