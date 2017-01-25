#!/usr/bin/env ruby
#encoding: UTF-8

require 'open-uri'
require 'nokogiri'


module OpenStock

  # 获取股票列表，返回err, [{:symbol=>symbol, :name=>name}, ...]
  def self.get_stock_list
    err = nil
    stock_list = []
    other_list = []

    url = "http://quote.eastmoney.com/stocklist.html"
    url = "http://fund.eastmoney.com/company/default.html"
    doc = Nokogiri::HTML(open(url).read.force_encoding(Encoding::GBK))
    # p doc.encoding

    quote_body = doc.css("div.quotebody")
    # p quote_body

    if quote_body.size == 0
      return "ERR_MISSING_DIV_QUOTEBODY", nil
    end

    lis = quote_body.css("li")
    # p lis

    lis.each do |li|
      name, symbol = li.css("a").text.gsub("(", "#").gsub(")", "").split("#")

      prefix = symbol[0..1]

      case prefix
      when "60" # SH
        symbol = "SH" + symbol
        stock_list << {:symbol=>symbol, :name=>name}

      when "00", "30" # SZ
        symbol = "SZ" + symbol
        stock_list << {:symbol=>symbol, :name=>name}

      else
        other_list << {:symbol=>symbol, :name=>name}
      end
    end

    # stock_list.each do |s|
      # puts "symbol: #{s[:symbol]}, name: #{s[:name].encode(Encoding::GBK)}"
    # end

    # puts "total: #{stock_list.size} stocks"

    # other_list.each do |s|
      # puts "symbol: #{s[:symbol]}, name: #{s[:name].encode(Encoding::GBK)}"
    # end

    return err, stock_list
  end



  # 获取实时价格
  # 返回: err, [[股票代码, 股票名称, 今日开盘价, 昨日收盘价, 当前价格, 今日最高价, 今日最低价, 竞买价, 竞卖价, 成交的股票数, 成交金额,
  #                  买一数量, 买一价格, 买二数量, 买二价格, 买三数量, 买三价格, 买四数量, 买四价格, 买五数量, 买五价格,
  #                  卖一数量, 卖一价格, 卖二数量, 卖二价格, 卖三数量, 卖三价格, 卖四数量, 卖四价格, 卖五数量, 卖五价格, 日期, 时间, 未知], ...]
  def self.get_quotes(symbol_array)
    # 新浪接口返回：var hq_str_sh601006="大秦铁路,..."
    #  0：”大秦铁路”，股票名称；
    #  1：”27.55″，今日开盘价；
    #  2：”27.25″，昨日收盘价；
    #  3：”26.91″，当前价格；
    #  4：”27.55″，今日最高价；
    #  5：”26.20″，今日最低价；
    #  6：”26.91″，竞买价，即“买一”报价；
    #  7：”26.92″，竞卖价，即“卖一”报价；
    #  8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
    #  9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
    # 10：”4695″，“买一”申请4695股，即47手；
    # 11：”26.91″，“买一”报价；
    # 12：”57590″，“买二”
    # 13：”26.90″，“买二”
    # 14：”14700″，“买三”
    # 15：”26.89″，“买三”
    # 16：”14300″，“买四”
    # 17：”26.88″，“买四”
    # 18：”15100″，“买五”
    # 19：”26.87″，“买五”
    # 20：”3100″，“卖一”申报3100股，即31手；
    # 21：”26.92″，“卖一”报价
    # (22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖四的情况”
    # 30：”2008-01-11″，日期；
    # 31：”15:05:32″，时间；
    # 32：”00″，未知；

    url = "http://hq.sinajs.cn/list=#{symbol_array.join(',').downcase}"
    doc = Nokogiri::HTML(open(url).read.force_encoding(Encoding::GBK))
    # p doc.text

    lines = doc.text.split("\n")
    # p lines

    rows = [["股票代码", "股票名称", "今日开盘价", "昨日收盘价", "当前价格", "今日最高价", "今日最低价", "竞买价", "竞卖价", "成交的股票数", "成交金额",
                "买一数量", "买一价格", "买二数量", "买二价格", "买三数量", "买三价格", "买四数量", "买四价格", "买五数量", "买五价格",
                "卖一数量", "卖一价格", "卖二数量", "卖二价格", "卖三数量", "卖三价格", "卖四数量", "卖四价格", "卖五数量", "卖五价格", "日期", "时间", "未知"]]

    lines.each do |line|
      symbol =  line.split("=")[0]
      if symbol
        symbol = symbol.split('_')[-1].strip.upcase
        # puts "symbol: ##{symbol}"

        line = line.split("\"")[1]

        if !line
          return "ERR_FORMAT", nil
        end

        rows << [symbol] + line.split(",")
        # puts row.split(",")
      end
    end

    return nil, rows
  end



  # 获取历史价格，不复权，返回err, [[日期, 开盘价, 最高价, 收盘价, 最低价, 交易量(股), 交易金额(元)], ...]
  def self.get_historical_quotes(symbol, start_date, end_date=Date.today())
    if start_date.class == String
      start_date = Date.strptime(start_date, "%Y-%m-%d")
    end

    if end_date.class == String
      end_date = Date.strptime(end_date, "%Y-%m-%d")
    end

    if (symbol.start_with?("SH000") || symbol.start_with?("SZ399"))
      url_template = "http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/%{symbol}/type/S.phtml?year=%{year}&jidu=%{jidu}" # 指数， SH000、SZ399开头
    else
      url_template = "http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/%{symbol}.phtml?year=%{year}&jidu=%{jidu}" # 个股
    end

    stripped_symbol = symbol[2..-1]

    # p stripped_symbol, start_date.to_s, end_date.to_s

    data_header = nil
    data_rows = []


    # 退到前一个季度
    loaded_season = next_season({:year=>end_date.year, :season=>month_to_season(end_date.month)})

    while loaded_season[:year] > start_date.year || loaded_season[:year] == start_date.year && loaded_season[:season] > month_to_season(start_date.month)
      new_season = prev_season(loaded_season)
      # p new_season

      url = url_template.gsub("%{symbol}", stripped_symbol).gsub("%{year}", new_season[:year].to_s).gsub("%{jidu}", new_season[:season].to_s)
      # p url

      doc = Nokogiri::HTML(open(url).read.force_encoding(Encoding::GBK))
      # p doc

      table_html = doc.css('table#FundHoldSharesTable')
      # p table_html

      #
      # 历史价格表格头第二行：日期 开盘价 最高价 收盘价 最低价 交易量(股) 交易金额(元)

      trs = table_html.css("tr")

      if trs != nil && trs[1] != nil
        td_names = trs[1].css("td").collect{|td| td.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")}

        if td_names[0] != "日期" || td_names[1] != "开盘价" || td_names[2] != "最高价" || td_names[3] != "收盘价" || td_names[4] != "最低价" || td_names[5] != "交易量(股)" || td_names[6] != "交易金额(元)"
          return "ERR_FORMAT", nil
        end

        if data_header == nil
          data_header = td_names
        end

        for i in 2..(trs.size-1)
          row = trs[i].css("td").collect{|td| td.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")}
          data_date = Date.strptime(row[0], "%Y-%m-%d")

          if data_date >= start_date && data_date <= end_date
            data_rows << row
          end
        end
      end

      loaded_season = new_season
    end

    return nil, [data_header] + data_rows
  end



  # 获取除权日在特定日期后（含）的分红、配股信息，返回err, [[公告日期, 税前红利, 送股比例, 转增比例, 配股比例, 配股价, 实际配股数, 配股前总股本, 实际配股比例, 登记日, 除息日, 上市日], ...]
  def self.get_share_bonus(symbol, since_date="1970-01-01")

    if since_date.class == String
      since_date = Date.strptime(since_date, "%Y-%m-%d")
    end

    stripped_symbol = symbol[2..-1]
    url = "http://vip.stock.finance.sina.com.cn/corp/go.php/vISSUE_ShareBonus/stockid/#{stripped_symbol}.phtml"
    doc = Nokogiri::HTML(open(url).read.force_encoding(Encoding::GBK))
    # p doc.encoding

    table1 = nil
    table2 = nil
    unified_table = nil

    begin # 分红信息
      table_html = doc.css("table#sharebonus_1")

      #
      # 分红信息表格头第一行：分红

      thead = table_html.css("thead")[0]

      if !thead
        return "ERR_MISSING_TABLE_HEADER", nil
      end

      thead_tr0 = thead.css("tr")[0]

      if !thead_tr0 || thead_tr0.text != "分红"
        return "ERR_TABLE1_HEADER1_FORMAT", nil
      end


      #
      # 分红信息表格头第二行：公告日期 分红方案(每10股)  进度  除权除息日 股权登记日 红股上市日 查看详细

      thead_tr1 = thead.css("tr")[1]
      thead_tr1_cols = thead_tr1.css("th")

      if thead_tr1_cols.size == 0
        thead_tr1_cols = thead_tr1.css("td")
      end

      if thead_tr1_cols.size != 7
        return "ERR_TABLE1_HEADER2_FORMAT", nil
      end

      sub_index = nil # 表格头第三行对应列
      data_header = [] # 表格头

      for i in 0..(thead_tr1_cols.size - 1)
        data_header << thead_tr1_cols[i].text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")

        if thead_tr1_cols[i].attr("colspan").to_i == 3
          sub_index = i
        end
      end

      if sub_index == nil
        return "ERR_TABLE1_HEADER3_FORMAT", nil
      end

      # puts "data_header: #{data_header}"


      #
      # 分红信息表格头第三行：送股(股)  转增(股) 派息(税前)(元)

      thead_tr2 = thead.css("tr")[2]
      thead_tr2_cols = thead_tr2.css("th")

      if thead_tr2_cols.size == 0
        thead_tr2_cols = thead_tr2.css("td")
      end

      if thead_tr2_cols.size != 3
        return "ERR_TABLE1_HEADER_LINE3_FORMAT", nil
      end

      sub_header = thead_tr2_cols.collect{|c| c.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")}
      # puts "sub_header: #{sub_header}"

      data_header[sub_index] = sub_header
      data_header.flatten!

      if data_header != ["公告日期", "送股(股)", "转增(股)", "派息(税前)(元)", "进度", "除权除息日", "股权登记日", "红股上市日", "查看详细"]
        puts "data_header: #{data_header}"
        return "ERR_TABLE1_HEADER_FORMAT", nil
      end

      #
      # 分红信息表格内容

      tbody = table_html.css("tbody")[0]
      tbody_trs = tbody.css("tr")

      table1 = [data_header]

      tbody_trs.each do |tr|
        row = []

        tr.css("td").each do |td|
          row << td.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "").gsub(",", "")
        end

        if row.size != data_header.size
          if row[0] == "暂时没有数据！"
            next
          else
            return "ERR_TABLE1_CONTENT_FORMAT", nil
          end
        end

        if !row[5].blank? && row[5] != "--" && Date.strptime(row[5], "%Y-%m-%d") >= since_date # 比较除权除息日
          row[-1] = "http://vip.stock.finance.sina.com.cn" + tr.css("td")[-1].css("a").attr("href").text
          table1 << row
        end
      end
    end


    begin # 配股
      table_html = doc.css("table#sharebonus_2")

      #
      # 配股信息表格头第一行：配股

      thead = table_html.css("thead")[0]

      thead_tr0 = thead.css("tr")[0]

      if !thead_tr0 || thead_tr0.text != "配股"
        return "ERR_TABLE2_HEADER1_FORMAT", nil
      end


      #
      # 配股信息表格头第二行：公告日期 配股方案(每10股配股股数)  配股价格(元) 基准股本(万股)  除权日 股权登记日 缴款起始日 缴款终止日 配股上市日 募集资金合计(元) 查看详细

      thead_tr1 = thead.css("tr")[1]
      thead_tr1_cols = thead_tr1.css("th")

      if thead_tr1_cols.size == 0
        thead_tr1_cols = thead_tr1.css("td")
      end

      data_header = thead_tr1_cols.collect{|c| c.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")}

      if data_header != ["公告日期", "配股方案(每10股配股股数)", "配股价格(元)", "基准股本(万股)", "除权日", "股权登记日", "缴款起始日", "缴款终止日", "配股上市日", "募集资金合计(元)", "查看详细"]
        return "ERR_TABLE2_HEADER2_FORMAT", nil
      end


      #
      # 配股信息表格内容

      tbody = table_html.css("tbody")[0]
      tbody_trs = tbody.css("tr")

      table2 = [data_header]

      tbody_trs.each do |tr|
        row = []

        tr.css("td").each do |td|
          row << td.text.gsub("\n", "").gsub("\r", "").gsub("\t", "").gsub(" ", "")
        end

        if row.size != data_header.size
          if row[0] == "暂时没有数据！"
            next
          else
            # STDERR.puts "table#sharebonus_2: row: #{row}, data_header: #{data_header}"
            return "ERR_TABLE2_CONTENT_FORMAT", nil
          end
        end

        if !row[4].blank? && row[4] != "--" && Date.strptime(row[4], "%Y-%m-%d") >= since_date # 比较除权除息日
          row[-1] = "http://vip.stock.finance.sina.com.cn" + tr.css("td")[-1].css("a").attr("href").text
          table2 << row
        end
      end
    end


    data_header = ["股东大会决议公告日期", "税前红利（报价币种）", "送股比例（10送）", "转增比例（10转增）", "配股比例（10配）", "配股价", "实际配股数", "配股前总股本", "实际配股比例", "登记日", "除息日", "上市日"]
    unified_hash = {} # key为除息日

    begin # 统一表格
      # 分红和送转股需要进一步获取上市日期
      for i in 1..table1.size-1
        raw_row = table1[i]

        # ["公告日期", "送股(股)", "转增(股)", "派息(税前)(元)", "进度", "除权除息日", "股权登记日", "红股上市日", "查看详细"]格式转换为data_header格式
        row = [raw_row[0], raw_row[3], raw_row[1], raw_row[2], "--", "--", "--", "--", "--", raw_row[6], raw_row[5], raw_row[7]]

        err, detail_hash = self.get_detail_hash(data_header, raw_row[-1])

        if err
          return err, nil
        end

        if row[11].blank? || row[11] == '--'
          row[11] = detail_hash["上市日"] || "--"
        end

        if row[0].blank? || row[0] == '--'
          row[0] = detail_hash["股东大会决议公告日期"] || "--"
        end

        unified_hash[raw_row[5]] = row
      end


      # 配股需要进一步获取实际配股数，上市日期
      for i in 1..table2.size-1
        raw_row = table2[i]

        # ["公告日期", "配股方案(每10股配股股数)", "配股价格(元)", "基准股本(万股)", "除权日", "股权登记日", "缴款起始日", "缴款终止日", "配股上市日", "募集资金合计(元)", "查看详细"]的raw_row转化为data_header格式
        row = [raw_row[0], "--", "--", "--", raw_row[1], raw_row[2], "--", raw_row[3], "--", raw_row[5], raw_row[4], raw_row[8]]

        err, detail_hash = self.get_detail_hash(data_header, raw_row[-1])

        if err
          return err, nil
        end

        # data_header.each do |col_name|
          # row << data_hash[col_name]
        # end

        row[6] = detail_hash["实际配股数"]
        row[8] = detail_hash["实际配股比例"]

        if row[11].blank? || row[11] == '--'
          row[11] = detail_hash["上市日"] || "--"
        end

        if row[0].blank? || row[0] == '--'
          row[0] = detail_hash["股东大会决议公告日期"] || "--"
        end

        # 有可能分红和配股在同一天，所以需要合并数据
        if unified_hash[row[10]] != nil
          unified_hash[row[10]][4] = row[4]   # 配股比例（10配）
          unified_hash[row[10]][5] = row[5]   # 配股价
          unified_hash[row[10]][6] = row[6]   # 实际配股数
          unified_hash[row[10]][7] = row[7]   # 配股前总股本
          unified_hash[row[10]][8] = row[8]   # 实际配股比例
        else
          unified_hash[row[10]] = row
        end
      end
    end

    return nil, [data_header] + unified_hash.values
  end


  private

  #
  # 获取data_header内指定的详细信息
  def self.get_detail_hash(data_header, detail_url)
    doc = Nokogiri::HTML(open(detail_url).read.force_encoding(Encoding::GBK))
    # p doc.encoding

    detail_hash = {}

    table = doc.css("table#sharebonusdetail")
    # p table

    trs = table.css("tr")

    trs.each do |tr|
      tds = tr.css("td")

      col_name = tds[0].text.strip  # 第一列的内容为键值

      if data_header.include?(col_name)
        detail_hash[col_name] = tds[1].text.strip.gsub(",", "")
      end
    end

    if detail_hash.size != data_header.size
      puts "detail_hash: #{detail_hash}, data_header: #{data_header}".encode(Encoding::GBK)
      return "ERR_DETAIL_FORMAT", nil
    end

    return nil, detail_hash
  end


  def self.month_to_season(month)
    (month - 1) / 3 + 1
  end


  def self.prev_season(jidu)
    new_season = jidu.dup

    if new_season[:season] == 1
      new_season[:season] = 4
      new_season[:year] -= 1
    else
      new_season[:season] -= 1
    end

    return new_season
  end


  def self.next_season(jidu)
    new_season = jidu.dup

    if new_season[:season] == 4
      new_season[:season] = 1
      new_season[:year] += 1
    else
      new_season[:season] += 1
    end

    return new_season
  end
end


#
# 示例代码：

# err, stock_list = OpenStock::get_stock_list()

# if err
  # puts err
  # exit -1
# end

# stock_list.each do |s|
  # puts "symbol: #{s[:symbol]}, name: #{s[:name].encode(Encoding::GBK)}"
# end


# err, prices = OpenStock::get_quotes(["SZ000001", "SZ000002"])
# if err
  # puts err
  # exit -1
# end

# prices.each do |pr|
  # puts pr.join(",")
# end

# require 'benchmark'
# Benchmark.bm do |x|
  # x.report {
    # err, prices = OpenStock::get_historical_quotes("SZ000001", Date.parse("2015-01-10"), "2015-09-01")

    # if err
      # puts err
      # exit -1
    # end

    # prices.each do |pr|
      # puts pr.join(",")
    # end
  # }
# end

# err, unified_table = OpenStock::get_share_bonus("SZ000001", "2000-01-01")

# if err
  # puts err
  # exit -1
# end

# unified_table.each do |row|
  # puts row.join(",").encode(Encoding::GBK)
# end

