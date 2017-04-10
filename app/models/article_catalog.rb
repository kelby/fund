# == Schema Information
#
# Table name: article_catalogs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ArticleCatalog < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  before_validation :set_slug

  has_many :article_categories

  def self.init_datas
    %W{分享与探索 V2EX iOS Geek Apple 生活 Internet 城市 品牌}.each do |name|
      self.create(name: name)
    end
  end

  def set_slug
    if self.name.present?
      self.slug ||= Pinyin.t(self.name, splitter: "").parameterize
    end
  end
end

# 分享与探索 问与答    分享发现    分享创造    分享邀请码    自言自语    奇思妙想    随想    设计    Blog
# V2EX  V2EX    Project Babel    DNS    反馈    Google App Engine    使用指南
# iOS iDev    iCode    iMarketing    iAd    iTransfer
# Geek  程序员    Python    Android    Linux    宽带症候群    PHP    云计算    外包    硬件    Java    服务器    MySQL    Bitcoin    Linode    编程    设计师    汽车    Kindle    Markdown    Tornado    MongoDB    Ruby on Rails    Redis    字体排印    Ruby    商业模式    数学    Photoshop    LEGO    SONY    自然语言处理
# Apple macOS    iPhone    MacBook Pro    iPad    MacBook    配件    MacBook Air    iMac    Mac mini    iPod    Mac Pro    MobileMe    iWork    iLife    GarageBand
# 生活  二手交易    酷工作    天黑以后    免费赠送    音乐    电影    物物交换    剧集    信用卡    美酒与美食    团购    投资    旅行    阅读    摄影    绿茵场    Baby    宠物    咖啡    乐活    骑行    非诚勿扰    日记    植物    蘑菇    行程控
# Internet  Google    Twitter    Coding    Facebook    Wikipedia    reddit
# 城市  北京    上海    深圳    杭州    成都    广州    武汉    昆明    天津    New York    San Francisco    青岛    Los Angeles    Boston
# 品牌  UNIQLO    Lamy    宜家    无印良品    Gap    Nike    Moleskine    Adidas    G-Star

