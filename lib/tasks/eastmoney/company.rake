require 'nokogiri'
require 'open-uri'

namespace :company do
  desc "company default"
  task :company_default => [:environment] do
    url = "http://localhost:3000/pages/company_default"

    # doc = Nokogiri::HTML(open url);
    sb = SpiderBase.new

    sb.page_for_url(url)

    datas = doc.css("#tbcompany")

    # datas.each do |data|
      # Catalog.find_or_create_by(name: '安信基金管理有限责任公司') { |catalog| catalog.set_up_at = '2011-12-06', scale: "374.00亿元 ", scale_record_at: ("2017-" + "01-20"), founder: "刘入领" }
    # end


    # Catalog.find_or_create_by(name: '安信基金管理有限责任公司') do |catalog|
    #   catalog.set_up_at = '2011-12-06'
    #   catalog.scale = "374.00亿元 "
    #   catalog.scale_record_at = ("2017-" + "01-20")
    #   catalog.founder = "刘入领"
    # end
  end

  desc "spicial company"
  task :spicial_compnay => [:environment] do
    # base_url = "http://fund.eastmoney.com/"

    # url = "http://fund.eastmoney.com/company/80205268.html"


    sb = SpiderBase.new


    Catalog.where.not(code: [nil, '']).each do |catalog|
      if catalog.projects.present?
        next
      end

      # catalog = Catalog.find_by(code: '80205268')
      url = "http://fund.eastmoney.com/company/#{catalog.code}.html"
      # catalog
      fetch_content = sb.page_for_url(url)
      doc = fetch_content.doc

      # doc = Nokogiri::HTML(open(url))

      # doc.encoding = 'gb2312'

      # catalog.update(raw_show_html: doc.to_html)

      company_dir = Rails.public_path.join("company/eastmoney")
      FileUtils::mkdir_p(company_dir)

      # yourfile = Rails.public_path.join("company/#{catalog.code}.html")
      file_name_with_path = company_dir.join("#{catalog.code}.html")


      begin
        File.open(file_name_with_path, 'w:GB2312') { |file| file.write(doc.to_html) }
      rescue Exception => e
        puts "=============Error #{catalog.code}"
      end
      # File.open(file_name_with_path, 'w') { |file| file.write(doc.to_html) }


      doc.css("#panels td.txt_left").each do |project_ele|
        name = project_ele.attributes['title'].value
        code = project_ele.children.last.text
        catalog_id = catalog.id

        if project_ele.present?
          mold_ele = project_ele.next_element.next_element
        else
          next
        end

        # begin
          Project.find_or_create_by(name: name, code: code, catalog_id: catalog_id) do |project|
            # project.mold = mold_ele.text if mold_ele.text.present?
          end
        # rescue Exception => e
          # ...
        # end
      end


      delay = rand(50)
      sleep(delay)
      puts "After catalog #{catalog.code}, sleep #{delay}."
    end


  end

  def doc
  end

  def fetch_project
  end
end


=begin

序号  基金公司名称  相关链接  成立时间  旗下基金数 管理规模日期  天相评级  总经理
1 安信基金管理有限责任公司  详情公司吧 2011-12-06  56       374.00亿元 01-20    暂无评级  刘入领
2 渤海证券股份有限公司  详情公司吧 2008-07-23  --- --- 暂无评级  周立
3 博时基金管理有限公司  详情公司吧 1998-07-13  244      3770.72亿元 01-20     ★★★ 江向阳
4 北信瑞丰基金管理有限公司  详情公司吧 2014-03-17  15       73.84亿元 12-31     暂无评级  朱彦
5 宝盈基金管理有限公司  详情公司吧 2001-05-18  26       432.44亿元 12-31    ★★★★★ 汪钦
6 长安基金管理有限公司  详情公司吧 2011-09-05  12       23.22亿元 01-20     ★★★★  黄陈
7 长城基金管理有限公司  详情公司吧 2001-12-27  52       1027.21亿元 01-20     ★★★ 熊科金
8 创金合信基金管理有限公司  详情公司吧 2014-07-09  39       142.73亿元 01-20    暂无评级  苏彦祝
9 长江证券(上海)资产管理有限公司  详情公司吧 2014-09-16  4      36.19亿元 12-31     暂无评级  唐吟波
10  长盛基金管理有限公司  详情公司吧 1999-03-26  95       733.62亿元 01-20    ★★★★  周兵
11  财通基金管理有限公司  详情公司吧 2011-06-21  14       214.71亿元 01-20    ★★★ 王家俊
12  财通证券资产管理有限公司  详情公司吧 2014-12-15  4      51.09亿元 12-31     暂无评级  马晓立
13  长信基金管理有限责任公司  详情公司吧 2003-05-09  66       639.14亿元 01-20    ★★★★★ 覃波
14  德邦基金管理有限公司  详情公司吧 2012-03-27  43       193.35亿元 01-20    暂无评级  易强
15  大成基金管理有限公司  详情公司吧 1999-04-12  120      1045.59亿元 01-20     ★★★ 罗登攀
16  东方基金管理有限责任公司  详情公司吧 2004-06-11  57       262.30亿元 01-16    ★★★★★ 刘鸿鹏
17  东海基金管理有限责任公司  详情公司吧 2013-02-25  5      10.28亿元 01-20     暂无评级  刘建锋
18  东吴基金管理有限公司  详情公司吧 2004-09-02  33       148.47亿元 12-31    ★★★ 王炯
19  东兴证券股份有限公司  详情公司吧 2008-05-28  6      70.97亿元 12-31     暂无评级  魏庆华
20  富安达基金管理有限公司 详情公司吧 2011-04-27  10       30.24亿元 01-13     ★★★★  蒋晓刚
21  富国基金管理有限公司  详情公司吧 1999-04-13  119      2091.24亿元 01-20     ★★★★★ 陈戈
22  富荣基金管理有限公司  详情公司吧 2016-01-25  2      31.08亿元 12-31     暂无评级  郭容辰
23  方正富邦基金管理有限公司  详情公司吧 2011-07-08  17       160.22亿元 01-20    ★★★ 邹牧
24  光大保德信基金管理有限公司 详情公司吧 2004-04-22  53       567.85亿元 01-20    ★★★★  包爱丽
25  国都证券股份有限公司  详情公司吧 2001-12-28  2      5.18亿元 12-31    暂无评级  常喆
26  广发基金管理有限公司  详情公司吧 2003-08-05  200      3007.41亿元 01-20     ★★★ 林传辉
27  国海富兰克林基金管理有限公司  详情公司吧 2004-11-15  44       203.41亿元 01-20    ★★★ 吴显玲
28  北京高华证券有限责任公司  详情公司吧 2004-10-18  --- --- 暂无评级  章星
29  国金基金管理有限公司  详情公司吧 2011-11-02  14       185.98亿元 12-31    ★★★★  尹庆军
30  国开泰富基金管理有限责任公司  详情公司吧 2013-07-16  6      17.81亿元 01-20     暂无评级  李鑫
31  国联安基金管理有限公司 详情公司吧 2003-04-03  53       410.29亿元 01-20    ★★★★  谭晓雨
32  格林基金管理有限公司  详情公司吧 2016-11-01  --- --- 暂无评级  高永红
33  国寿安保基金管理有限公司  详情公司吧 2013-10-29  42       788.84亿元 01-20    暂无评级  左季庆
34  国泰基金管理有限公司  详情公司吧 1998-03-05  116      771.02亿元 01-20    ★★★★★ 周向勇
35  国投瑞银基金管理有限公司  详情公司吧 2002-06-13  87       930.41亿元 01-20    ★★★ 王彬
36  工银瑞信基金管理有限公司  详情公司吧 2005-06-21  146      4603.67亿元 01-20     暂无评级  郭特华
37  华安基金管理有限公司  详情公司吧 1998-06-04  141      1626.35亿元 01-20     ★★★★★ 童威
38  汇安基金管理有限责任公司  详情公司吧 2016-04-25  15       15.64亿元 01-20     暂无评级  秦军
39  华宝兴业基金管理有限公司  详情公司吧 2003-03-07  66       1205.31亿元 01-20     ★★★ 黄小薏
40  华宸未来基金管理有限公司  详情公司吧 2012-06-20  1      0.18亿元 12-31    暂无评级  杨桐
41  泓德基金管理有限公司  详情公司吧 2015-03-03  23       181.29亿元 01-20    暂无评级  王德晓
42  华富基金管理有限公司  详情公司吧 2004-04-19  46       142.51亿元 01-20    ★★★ 余海春
43  汇丰晋信基金管理有限公司  详情公司吧 2005-11-16  24       173.15亿元 01-13    ★★★ 王栋
44  海富通基金管理有限公司 详情公司吧 2003-04-18  57       442.10亿元 01-20    ★★★ 刘颂
45  华润元大基金管理有限公司  详情公司吧 2013-01-17  13       24.15亿元 01-13     暂无评级  林瑞源
46  华融证券股份有限公司  详情公司吧 2007-09-07  5      6.53亿元 12-31    暂无评级  樊平(代)
47  华商基金管理有限公司  详情公司吧 2005-12-20  47       480.03亿元 01-20    ★★★★  梁永强
48  恒生前海基金管理有限公司  详情公司吧 2016-07-01  --- --- 暂无评级  刘宇
49  华泰柏瑞基金管理有限公司  详情公司吧 2004-11-18  68       975.21亿元 01-20    ★★★ 韩勇
50  华泰保兴基金管理有限公司  详情公司吧 2016-07-26  1 --- 暂无评级  王冠龙
51  红土创新基金管理有限公司  详情公司吧 2014-06-18  3      3.56亿元 01-20    暂无评级  邵钢(代)
52  汇添富基金管理股份有限公司 详情公司吧 2005-02-03  111      2711.05亿元 01-20     ★★★★★ 张晖
53  红塔红土基金管理有限公司  详情公司吧 2012-06-12  11       9.78亿元 01-20    暂无评级  刘辉
54  华夏基金管理有限公司  详情公司吧 1998-04-09  152      4009.27亿元 01-20     ★★★ 汤晓东
55  嘉合基金管理有限公司  详情公司吧 2014-07-30  4      30.87亿元 12-31     暂无评级  徐岱
56  景顺长城基金管理有限公司  详情公司吧 2003-06-12  87       869.25亿元 01-20    ★★★★  许义明
57  嘉实基金管理有限公司  详情公司吧 1999-03-25  147      3380.15亿元 01-20     ★★★★  赵学军
58  九泰基金管理有限公司  详情公司吧 2014-07-03  22       120.95亿元 01-20    暂无评级  卢伟忠
59  江信基金管理有限公司  详情公司吧 2013-01-28  11       33.37亿元 01-20     暂无评级  初英
60  金信基金管理有限公司  详情公司吧 2015-07-03  7      5.17亿元 12-31    暂无评级  殷克胜
61  建信基金管理有限责任公司  详情公司吧 2005-09-19  117      3771.40亿元 01-20     ★★★★  孙志晨
62  金鹰基金管理有限公司  详情公司吧 2002-12-25  42       255.54亿元 01-20    暂无评级  刘岩
63  金元顺安基金管理有限公司  详情公司吧 2006-11-13  15       76.04亿元 01-20     暂无评级  张嘉宾
64  交银施罗德基金管理有限公司 详情公司吧 2005-08-04  100      1023.79亿元 01-20     ★★★★  阮红
65  摩根士丹利华鑫基金管理有限公司 详情公司吧 2003-03-14  30       297.44亿元 01-20    ★★★★★ 高潮生
66  民生加银基金管理有限公司  详情公司吧 2008-11-03  61       789.29亿元 01-20    ★★★★  吴剑飞
67  诺安基金管理有限公司  详情公司吧 2003-12-09  70       947.22亿元 01-20    ★★★★★ 奥成文
68  诺德基金管理有限公司  详情公司吧 2006-06-08  16       56.16亿元 12-31     暂无评级  胡志伟
69  南方基金管理有限公司  详情公司吧 1998-03-06  173      3857.69亿元 01-20     ★★★★★ 杨小松
70  南华基金管理有限公司  详情公司吧 2016-11-17  --- --- 暂无评级  董浏洋
71  农银汇理基金管理有限公司  详情公司吧 2008-03-18  44       1130.60亿元 01-20     ★★★ 许金超
72  平安大华基金管理有限公司  详情公司吧 2011-01-07  43       836.77亿元 01-20    暂无评级  肖宇鹏
73  鹏华基金管理有限公司  详情公司吧 1998-12-22  202      2507.70亿元 01-20     ★★★ 邓召明
74  浦银安盛基金管理有限公司  详情公司吧 2007-08-05  50       525.72亿元 01-20    ★★★★★ 郁蓓华
75  鹏扬基金管理有限公司  详情公司吧 2016-07-06  --- --- 暂无评级  杨爱斌
76  前海开源基金管理有限公司  详情公司吧 2013-01-23  73       607.25亿元 01-20    暂无评级  蔡颖
77  新疆前海联合基金管理有限公司  详情公司吧 2015-08-07  13       138.26亿元 12-31    暂无评级  王晓耕
78  融通基金管理有限公司  详情公司吧 2001-05-22  85       894.60亿元 01-06    暂无评级  孟朝霞
79  上海东方证券资产管理有限公司  详情公司吧 2010-06-08  35       364.71亿元 01-20    暂无评级  任莉
80  上投摩根基金管理有限公司  详情公司吧 2004-05-12  81       1383.89亿元 01-20     ★★★ 章硕麟
81  申万菱信基金管理有限公司  详情公司吧 2004-01-15  50       342.96亿元 01-13    ★★★ 来肖贤
82  山西证券股份有限公司  详情公司吧 1988-07-28  7      51.52亿元 01-20     暂无评级  侯巍
83  上银基金管理有限公司  详情公司吧 2013-08-30  5      534.11亿元 12-31    暂无评级  李永飞
84  泰达宏利基金管理有限公司  详情公司吧 2002-06-06  70       494.86亿元 12-31    ★★★ 刘建
85  天弘基金管理有限公司  详情公司吧 2004-11-08  81       8449.81亿元 01-20     ★★★ 郭树强
86  泰康资产管理有限责任公司  详情公司吧 2006-02-21  20       85.79亿元 01-20     暂无评级  段国圣
87  太平基金管理有限公司  详情公司吧 2013-01-23  3      151.65亿元 12-31    暂无评级  宋小龙
88  泰信基金管理有限公司  详情公司吧 2003-05-23  27       62.09亿元 01-20     ★★★ 葛航
89  天治基金管理有限公司  详情公司吧 2003-05-27  14       25.83亿元 01-20     暂无评级  常永涛
90  万家基金管理有限公司  详情公司吧 2002-08-23  72       523.59亿元 01-20    暂无评级  经晓云
91  西部利得基金管理有限公司  详情公司吧 2010-07-20  36       147.22亿元 12-31    暂无评级  贺燕萍
92  信诚基金管理有限公司  详情公司吧 2005-09-30  111      649.04亿元 01-20    ★★★★  吕涛
93  信达澳银基金管理有限公司  详情公司吧 2006-06-05  20       186.13亿元 01-20    暂无评级  于建伟
94  先锋基金管理有限公司  详情公司吧 2016-05-16  3      10.71亿元 12-31     暂无评级  齐靠民
95  新华基金管理股份有限公司  详情公司吧 2004-12-09  58       442.98亿元 01-20    ★★★ 张宗友
96  兴全基金管理有限公司  详情公司吧 2003-09-30  21       1111.07亿元 01-13     ★★★★★ 杨东
97  新沃基金管理有限公司  详情公司吧 2015-08-19  6      52.35亿元 01-20     暂无评级  库三七
98  鑫元基金管理有限公司  详情公司吧 2013-08-29  25       250.73亿元 01-20    暂无评级  张乐赛
99  兴业基金管理有限公司  详情公司吧 2013-04-17  52       1326.80亿元 01-20     暂无评级  汤夕生
100 兴银基金管理有限责任公司  详情公司吧 2013-10-25  16       653.09亿元 01-20    暂无评级  张力
101 英大基金管理有限公司  详情公司吧 2012-08-17  12       21.26亿元 01-20     暂无评级  张传良(代)
102 易方达基金管理有限公司 详情公司吧 2001-04-17  174      4172.38亿元 01-20     ★★★★  刘晓艳
103 银河基金管理有限公司  详情公司吧 2002-06-14  66       656.22亿元 01-20    ★★★ 刘立达
104 银华基金管理股份有限公司  详情公司吧 2001-05-28  109      1633.26亿元 01-20     ★★★★  王立新
105 益民基金管理有限公司  详情公司吧 2005-12-12  7      18.44亿元 12-31     暂无评级  黄桦
106 圆信永丰基金管理有限公司  详情公司吧 2014-01-02  11       80.98亿元 12-31     暂无评级  董晓亮
107 永赢基金管理有限公司  详情公司吧 2013-11-07  9      43.04亿元 12-31     暂无评级  芦特尔
108 中海基金管理有限公司  详情公司吧 2004-03-18  47       342.41亿元 01-20    暂无评级  黄鹏
109 中航基金管理有限公司  详情公司吧 2016-06-16  1 --- 暂无评级  陈四汝
110 中金基金管理有限公司  详情公司吧 2014-02-10  13       35.64亿元 12-31     暂无评级  孙菁
111 中加基金管理有限公司  详情公司吧 2013-03-27  18       413.80亿元 01-20    暂无评级  夏英
112 中科沃土基金管理有限公司  详情公司吧 2015-09-06  3      13.18亿元 01-20     暂无评级  杨绍基
113 中欧基金管理有限公司  详情公司吧 2006-07-19  100      776.86亿元 01-20    ★★★★★ 刘建平
114 中融基金管理有限公司  详情公司吧 2013-05-31  62       420.07亿元 01-20    暂无评级  杨凯
115 招商基金管理有限公司  详情公司吧 2002-12-27  213      3457.59亿元 01-20     ★★★ 金旭
116 浙商基金管理有限公司  详情公司吧 2010-10-21  20       119.55亿元 01-20    ★★★★  李志惠
117 浙江浙商证券资产管理有限公司  详情公司吧 2013-04-18  7      14.36亿元 01-20     暂无评级  李雪峰
118 中信建投基金管理有限公司  详情公司吧 2013-09-09  15       94.61亿元 01-20     暂无评级  张杰
119 中银国际证券有限责任公司  详情公司吧 2002-02-28  8      369.43亿元 12-31    暂无评级  宁敏
120 中邮创业基金管理股份有限公司  详情公司吧 2006-05-08  38       623.24亿元 01-20    ★★★★★ 周克
121 中银基金管理有限公司  详情公司吧 2004-08-12  103      3421.74亿元 01-20     ★★★ 李道滨
=end