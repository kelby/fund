# == Schema Information
#
# Table name: article_categories
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  slug               :string(255)
#  cover              :string(255)
#  intro              :string(255)
#  article_catalog_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  articles_count     :integer          default(0), not null
#  top_at             :datetime
#

class ArticleCategory < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :article_catalog_id

  before_validation :set_slug

  has_many :articles
  belongs_to :article_catalog

  def set_slug
    if self.name.present?
      self.slug ||= Pinyin.t(self.name, splitter: "").parameterize
    end
  end

  def self.init_datas
    [%W(分享与探索 问与答    分享发现    分享创造    分享邀请码    自言自语    奇思妙想    随想    设计    Blog   ),
    %W(V2EX  V2EX    Project    DNS    反馈    GAE    使用指南   ),
    %W(iOS iDev    iCode    iMarketing    iAd    iTransfer),
    %W(Geek  程序员    Python    Android    Linux    宽带症候群    PHP    云计算    外包    硬件    Java    服务器    MySQL    Bitcoin    Linode    编程    设计师    汽车    Kindle    Markdown    Tornado    MongoDB    Rails    Redis    字体排印    Ruby    商业模式    数学    Photoshop    LEGO    SONY    自然语言处理),
    %W(Apple macOS    iPhone    MacBook    iPad        配件        iMac    Mac    iPod        MobileMe    iWork    iLife    GarageBand),
    %W(生活  二手交易    酷工作    天黑以后    免费赠送    音乐    电影    物物交换    剧集    信用卡    美酒与美食    团购    投资    旅行    阅读    摄影    绿茵场    Baby    宠物    咖啡    乐活    骑行    非诚勿扰    日记    植物    蘑菇    行程控),
    %W(Internet  Google    Twitter    Coding    Facebook    Wikipedia    reddit),
    %W(城市  北京    上海    深圳    杭州    成都    广州    武汉    昆明    天津   青岛),
    %W(品牌  UNIQLO    Lamy    宜家    无印良品    Gap    Nike    Moleskine    Adidas    G-Star)].each do |catalog_with_array|
      catalog_name = catalog_with_array[0]
      catalog = ArticleCatalog.find_by(name: catalog_name)

      catalog_with_array.each_with_index do |category_name, index|
        if index.zero?
          next
        else
          catalog.article_categories.create(name: category_name)
        end
      end
    end
  end
end

