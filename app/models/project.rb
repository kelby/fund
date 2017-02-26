# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  description          :text(65535)
#  website              :string(255)
#  wiki                 :string(255)
#  source_code          :string(255)
#  category_id          :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  identity             :integer          default("unknow")
#  author               :text(65535)
#  status               :integer          default("pending")
#  popularity           :decimal(15, 2)
#  developer_id         :integer
#  today_recommend      :boolean
#  recommend_at         :datetime
#  human_name           :string(255)
#  given_name           :string(255)
#  view_times           :integer          default(0)
#  code                 :string(255)
#  catalog_id           :integer
#  mold                 :string(255)
#  slug                 :string(255)
#  set_up_at            :date
#  mother_son           :integer          default("mother_son_normal")
#  release_status       :integer          default("release_end")
#  comments_count       :integer          default(0)
#  mold_type            :integer          default("mold_not_set")
#  fund_chai_fens_count :integer          default(0), not null
#  fund_fen_hongs_count :integer          default(0), not null
#

require 'elasticsearch/model'

class Project < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  include Searchable

  # Associations
  belongs_to :catalog, counter_cache: true

  belongs_to :category # , counter_cache: true
  counter_culture :category
  counter_culture :category, :column_name => proc {|model| model.online? ? 'online_projects_count' : nil }

  # belongs_to :developer

  has_one :github_info

  has_one :gem_info
  has_one :pod_info
  has_one :package_info

  has_one :fund_raise
  has_one :fund_jbgk
  has_many :fund_jbgks

  has_many :comments, as: :commentable

  has_many :user_star_projects
  has_many :user_recommend_projects

  has_many :star_by_users, through: :user_star_projects, source: :user
  has_many :recommend_by_users, through: :user_recommend_projects, source: :user

  has_many :net_worths

  has_many :asset_allocations
  has_one :default_asset_allocation, -> { order(record_at: :desc).limit(1) }, class_name: 'AssetAllocation'


  has_many :developer_projects, -> { desc }
  has_many :developers, through: :developer_projects
  has_many :online_developer_projects, -> { online }, class_name: "DeveloperProject"
  has_many :online_developers, through: :online_developer_projects, source: :developer


  # 关系比较复杂时，先从简单的开始。所以，这是第二步
  has_many :son_project_associations, class_name: 'Kinsfolk', foreign_key: :mother_id
  # 关系比较复杂时，先从简单的开始。有了第二步，自然到这第三步
  has_many :son_projects, class_name: 'Project', through: :son_project_associations, foreign_key: :mother_id

  # 关系比较复杂时，先从简单的开始。所以，这是第二步
  has_one :mother_project_association, class_name: 'Kinsfolk', foreign_key: :son_id
  # 关系比较复杂时，先从简单的开始。有了第二步，自然到这第三步
  has_one :mother_project, class_name: 'Project', through: :mother_project_association, foreign_key: :son_id

  has_many :project_items

  has_many :fund_chai_fens
  has_many :fund_fen_hongs

  has_many :fund_rankings
  has_one :lastest_fund_ranking, class_name: 'FundRanking'

  has_many :fund_yields


  has_one :last_one_week_yield, ->{where(yield_type: FundYield.yield_types['last_one_week'])}, class_name: 'FundYield'
  has_one :last_one_month_yield, ->{where(yield_type: FundYield.yield_types['last_one_month'])}, class_name: 'FundYield'
  has_one :last_two_month_yield, ->{where(yield_type: FundYield.yield_types['last_two_month'])}, class_name: 'FundYield'
  has_one :last_three_month_yield, ->{where(yield_type: FundYield.yield_types['last_three_month'])}, class_name: 'FundYield'
  has_one :last_six_month_yield, ->{where(yield_type: FundYield.yield_types['last_six_month'])}, class_name: 'FundYield'
  has_one :last_one_year_yield, ->{where(yield_type: FundYield.yield_types['last_one_year'])}, class_name: 'FundYield'
  has_one :last_two_year_yield, ->{where(yield_type: FundYield.yield_types['last_two_year'])}, class_name: 'FundYield'
  has_one :last_three_year_yield, ->{where(yield_type: FundYield.yield_types['last_three_year'])}, class_name: 'FundYield'
  has_one :this_year_yield, ->{where(yield_type: FundYield.yield_types['this_year'])}, class_name: 'FundYield'
  has_one :last_five_year_yield, ->{where(yield_type: FundYield.yield_types['last_five_year'])}, class_name: 'FundYield'
  has_one :last_seven_year_yield, ->{where(yield_type: FundYield.yield_types['last_seven_year'])}, class_name: 'FundYield'
  has_one :last_ten_year_yield, ->{where(yield_type: FundYield.yield_types['last_ten_year'])}, class_name: 'FundYield'
  has_one :since_the_inception_yield, ->{where(yield_type: FundYield.yield_types['since_the_inception'])}, class_name: 'FundYield'
  # END


  delegate :name, to: :catalog, allow_nil: true, prefix: true

  delegate :net_asset, to: :default_asset_allocation, allow_nil: true, prefix: false
  delegate :record_at, to: :default_asset_allocation, allow_nil: true, prefix: false


  MOLD_TYPE_HASH = {'mold_gp' => "股票型", 'mold_hh' => "混合型", 'mold_zq' => "债券型",
    'mold_zs' => "指数型", 'mold_qdii' => "QDII", 'mold_etf' => "ETF联接", 'mold_lof' => "LOF",
    'mold_cnjy' => "场内交易基金", 'mold_cx' => "创新型", 'mold_fof' => "FOF",
    'mold_bb' => "保本型", 'mold_lc' => "理财", 'mold_hb' => "货币型", 'mold_fj' => "分级基金"}

  RELEASE_STATUS_HASH = {'release_end' => "发行完毕", 'release_now' => "正在发行",
    'release_will' => "将要发行", 'release_not_set' => "发行状态未知"}

  # Rails class methods
  enum identity: {unknow: 0, gemspec: 2, package: 4, pod: 6}

  # 等待处理，下线，上线；Star 数目小于100; 长时间不更新、废弃；只是单纯的github项目、不是插件
  enum status: {pending: 0, offline: 4, online: 6, nightspot: 8,
    deprecated: 10, site_invalid: 12, not_want: 14}

  # 分级基金的母子特性
  enum mother_son: { mother_son_normal: 0, mother: 2, son: 4 }

  # 发行状态：已发行完毕，正常买卖、或暂停；正在发行；将要发行
  enum release_status: { release_end: 0, release_now: 2, release_will: 4, release_not_set: 6 }

  scope :confirm_lineal, -> { where(mother_son: [Project.mother_sons['mother_son_normal'], Project.mother_sons['mother']]) }
  scope :nolimit, -> { unscope(:limit, :offset) }
  scope :show_status, -> { where(status: [Project.statuses['online'], Project.statuses['nightspot'], Project.statuses['deprecated']]) }

  enum mold_type: {mold_not_set: 0, mold_gp: 2, mold_hh: 4, mold_zq: 6, mold_zs: 8, mold_qdii: 10,
    mold_etf: 12, mold_lof: 14, mold_cnjy: 16, mold_cx: 18, mold_fof: 20,
    mold_bb: 22, mold_lc: 24, mold_hb: 26, mold_fj: 28}

  scope :not_hb_lc, -> {where(mold_type: [22, 24, 26])}

  scope :by_join_date, -> {order(id: :desc)}
  # END


  # Validates
  # validates_presence_of :source_code
  # validates_presence_of :category_id

  validates_uniqueness_of :name, scope: :author, message: "该用户的项目已经存在，您不必重复添加"
  # END


  # Callbacks
  # after_commit :logic_set_gem_info, on: :create
  # after_commit :logic_set_pod_info, on: :create
  # after_commit :logic_set_package_info, on: :create

  # after_commit :set_github_info, on: :create

  # after_create :aysc_set_developer_info
  # after_commit :set_readme, on: :create

  # after_create :build_github_info

  # before_validation :set_github_identity

  before_create :set_slug

  after_update :detect_and_set_recommend_at
  after_update :detect_given_name_changed
  after_update :detect_set_category_online
  # END


  # Constants
  # API_GITHUB = "https://api.github.com/"

  # RAILS_BASE = {'watchers' => 2321, 'stars' => 33566, 'forks' => 13698, 'downloads' => 81138762}
  # SWIFT_BASE = {'watchers' => 2406, 'stars' => 35406, 'forks' => 5135, 'downloads' => 81138762}
  # LARAVEL_BASE = {'watchers' => 3522, 'stars' => 27582, 'forks' => 9131, 'downloads' => 3941137}
  # END

  # Plugins
  acts_as_taggable
  # END

  def api_begin_net_worth(begin_date)
    begin_date = begin_date.to_time.strftime("%F")

    # 1) 当天是交易日，直接获取
    # api_net_worth = self.net_worths.find_by(record_at: begin_date)

    # if api_net_worth.blank?
      # 2) 当天不是交易日，取上一个交易日 (小于、从大到小、第一个)
      # api_net_worth = self.net_worths.where("record_at < ?", begin_date).desc.first
    # end

    # 上述 1, 2 注释的合并写法
    api_net_worth = self.net_worths.where("record_at <= ?", begin_date).desc.first

    if api_net_worth.blank?
      # 3) 开始时间太早，还没有交易数据，取首个交易日
      api_net_worth = self.net_worths.asc.first
    end

    api_net_worth
  end

  def api_end_net_worth(end_date)
    end_date = end_date.to_time.strftime("%F")

    # 1) 当天是交易日，直接获取
    # api_net_worth = self.net_worths.find_by(record_at: end_date)

    # if api_net_worth.blank?
      # 2) 当天不是交易日，取上一个交易日 (小于、从大到小、第一个)
      # api_net_worth = self.net_worths.where("record_at < ?", end_date).desc.first
    # end

    # 上述 1, 2 注释的合并写法
    api_net_worth = self.net_worths.where("record_at <= ?", end_date).desc.first

    api_net_worth
  end

  def api_fund_fen_hongs(begin_date, end_date)
    begin_date = begin_date.to_time.strftime("%F")
    end_date = end_date.to_time.strftime("%F")

    self.fund_fen_hongs.where(the_real_ex_dividend_at: begin_date..end_date).desc
  end

  def api_fund_chai_fens(begin_date, end_date)
    begin_date = begin_date.to_time.strftime("%F")
    end_date = end_date.to_time.strftime("%F")

    self.fund_chai_fens.where(the_real_break_convert_at: begin_date..end_date).desc
  end

  def api_get_fund_yield_from_to(begin_date, end_date)
    begin_date = begin_date.to_time.strftime("%F")
    end_date = end_date.to_time.strftime("%F")

    api_begin_net_worth = api_begin_net_worth(begin_date)
    api_end_net_worth = api_end_net_worth(end_date)

    if api_begin_net_worth.blank? || api_end_net_worth.blank?
      return {}
    end

    if api_fund_fen_hongs.blank? && api_fund_chai_fens.blank?
      yield_rate = ((api_end_net_worth.dwjz - api_begin_net_worth.dwjz) / api_begin_net_worth.dwjz * 100).round(2)

      return {begin_date: begin_date, end_date: end_date,
        yield_rate: yield_rate,
        beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
        beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
        fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
        project_code: self.code}
    end

    if api_fund_fen_hongs.blank? && api_fund_chai_fens.present?
      break_ratio = api_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.map(&:*).round(4)
      
      yield_rate = ((api_end_net_worth.dwjz * break_ratio - api_begin_net_worth.dwjz) / api_begin_net_worth.dwjz * 100).round(2)

      return {begin_date: begin_date, end_date: end_date,
        yield_rate: yield_rate,
        beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
        beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
        fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
        project_code: self.code}
    end


    if api_fund_fen_hongs.present? && api_fund_chai_fens.blank?
      if api_fund_fen_hongs.one?
        api_fund_fen_hong = api_fund_fen_hongs.first

        # fen_hong_day_dwjz = api_fund_fen_hong.net_worth.dwjz

        yield_rate = ((((api_fund_fen_hong.net_worth.dwjz + api_fund_fen_hong.bonus) / api_begin_net_worth.dwjz) * (api_end_net_worth.dwjz / api_fund_fen_hong.net_worth.dwjz) - 1) * 100).round(2)

        return {begin_date: begin_date, end_date: end_date,
          yield_rate: yield_rate,
          beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
          beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
          fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
          project_code: self.code}
      else
        api_end_fund_fen_hong = api_fund_fen_hongs.first
        api_begin_fund_fen_hong = api_fund_fen_hongs.last




        # _involve_net_worth  = self.net_worths.where(record_at: _fund_fen_hongs.pluck(:ex_dividend_at)).order(record_at: :asc)

        # ...
        # _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)
        # _first_fund_chai_fen = _fund_chai_fens.first
        # _end_chai_fen_factor = _end_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

        # if _end_chai_fen_factor.present?
          # _end_chai_fen_factor = _end_chai_fen_factor.round(4)
        # else
          # _end_chai_fen_factor = 1
        # end

        end_ratio = api_end_net_worth.dwjz / api_end_fund_fen_hong.dwjz

        # ...
        # _begin_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: target_net_worth.record_at.._first_fund_fen_hong.ex_dividend_at).order(break_convert_at: :asc)
        # _first_fund_chai_fen = _fund_chai_fens.first
        # _begin_chai_fen_factor = _begin_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

        # if _begin_chai_fen_factor.present?
          # _begin_chai_fen_factor = _begin_chai_fen_factor.round(4)
        # else
          # _begin_chai_fen_factor = 1
        # end

        begin_ratio = (api_begin_fund_fen_hong.dwjz + api_begin_fund_fen_hong.bonus) / api_begin_net_worth.dwjz

        middle_ratio = 1

        api_fund_fen_hongs.each_with_index do |_fund_fen_hong, index|
          _prev_fund_fen_hong = api_fund_fen_hongs[index + 1]

          if _prev_fund_fen_hong.blank?
            break
          end

          middle_ratio = middle_ratio * (_fund_fen_hong.dwjz + _fund_fen_hong.bonus) / _prev_fund_fen_hong.dwjz
          # if index.zero?
            # next
          # end

          # ...

          # (_fund_fen_hong.dwjz + _fund_fen_hong.bonus) /

          # 2017-02-03  1.1723  1.7623  -0.5%

          # 2016-11-28  1.1785  1.7685  0.25%

          # 2015-11-25  1.2388  1.5888  0.15%

          # 2007-00-00  1       1       0%

          # 年份  权益登记日 除息日 每份分红  分红发放日
          # 2016年 2016-11-28  2016-11-28  每份派现金 0.2400 元  2016-11-30
          # 2015年 2015-11-25  2015-11-25  每份派现金 0.3500 元  2015-11-27

          # inner_new_fen_hong = _fund_fen_hong
          # inner_old_fen_hong = _fund_fen_hongs[index - 1]

          # ...
          # _inner_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: inner_old_fen_hong.ex_dividend_at..inner_new_fen_hong.ex_dividend_at).order(break_convert_at: :asc)
          # _first_fund_chai_fen = _fund_chai_fens.first
          # _inner_chai_fen_factor = _inner_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

          # if _inner_chai_fen_factor.blank?
            # _inner_chai_fen_factor = 1
          # end

          # _x = _x * ((inner_new_fen_hong.dwjz + inner_new_fen_hong.bonus) * _inner_chai_fen_factor / (inner_old_fen_hong.dwjz))
        end

        yield_rate = ((end_ratio * begin_ratio * middle_ratio - 1) * 100).round(2)

        return {begin_date: begin_date, end_date: end_date,
          yield_rate: yield_rate,
          beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
          beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
          fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
          project_code: self.code}

        # (( ((1.2388 + 0.3500)/1) * ((1.1785 + 0.2400)/1.2388) * (1.1723/1.1785) - 1) * 100).round(2)
        # 80.97
        # ((end_ratio * begin_ration * _x - 1) * 100).round(2)

        # (api_end_net_worth.dwjz - )

        # api_fund_fen_hongs.each_with_index do |api_fund_fen_hong, index|
          # api_fund_fen_hong.dwjz

          # 2017-02-03  1.1723  1.7623  -0.5%

          # 2016-11-28  1.1785  1.7685  0.25%

          # 2015-11-25  1.2388  1.5888  0.15%

          # 2007-00-00  1       1       0%

          # 年份  权益登记日 除息日 每份分红  分红发放日
          # 2016年 2016-11-28  2016-11-28  每份派现金 0.2400 元  2016-11-30
          # 2015年 2015-11-25  2015-11-25  每份派现金 0.3500 元  2015-11-27

          # ((((api_fund_fen_hong.dwjz + 0.3500)/1) * ((1.1785 + 0.2400)/1.2388) * (1.1723/1.1785) - 1) * 100).round(2)

        # end
      end
    end

    if api_fund_fen_hongs.present? && api_fund_chai_fens.present?
      if api_fund_fen_hongs.one?
        api_fund_fen_hong = api_fund_fen_hongs.first

        # fen_hong_day_dwjz = api_fund_fen_hong.net_worth.dwjz

        pre_fen_hong_chai_fens = api_fund_chai_fens.where(the_real_break_convert_at: api_begin_net_worth.record_at..api_fund_fen_hong.net_worth.record_at)
        post_fen_hong_chai_fens = api_fund_chai_fens.where(the_real_break_convert_at: api_fund_fen_hong.net_worth.record_at..api_end_net_worth.record_at)

        pre_fen_hong_ratio = pre_fen_hong_chai_fens.map { |e| e.get_break_ratio_to_f }.map(&:*)
        post_fen_hong_ratio = post_fen_hong_chai_fens.map { |e| e.get_break_ratio_to_f }.map(&:*)

        if pre_fen_hong_ratio.present?
          pre_fen_hong_ratio = pre_fen_hong_ratio.round(4)
        else
          pre_fen_hong_ratio = 1
        end

        if post_fen_hong_ratio.present?
          post_fen_hong_ratio = post_fen_hong_ratio.round(4)
        else
          post_fen_hong_ratio = 1
        end

        yield_rate = ((((api_fund_fen_hong.net_worth.dwjz + api_fund_fen_hong.bonus) * pre_fen_hong_ratio / api_begin_net_worth.dwjz) * (api_end_net_worth.dwjz * post_fen_hong_ratio / api_fund_fen_hong.net_worth.dwjz) - 1) * 100).round(2)

        return {begin_date: begin_date, end_date: end_date,
          yield_rate: yield_rate,
          beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
          beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
          fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
          project_code: self.code}
      else
        api_end_fund_fen_hong = api_fund_fen_hongs.first
        api_begin_fund_fen_hong = api_fund_fen_hongs.last

        end_ratio = api_fund_chai_fens.where(the_real_break_convert_at: api_fund_fen_hong.the_real_ex_dividend_at..api_end_net_worth.record_at).map { |e| e.get_break_ratio_to_f }.map(&:*)

        if end_ratio.present?
          end_ratio = end_ratio.round(4)
        else
          end_ratio = 1
        end

        end_rate = api_end_net_worth.dwjz * end_ratio / api_end_fund_fen_hong.net_worth.dwjz


        begin_ratio = api_fund_chai_fens.where(the_real_break_convert_at: api_fund_fen_hong.the_real_ex_dividend_at..api_end_net_worth.record_at).map { |e| e.get_break_ratio_to_f }.map(&:*)

        if begin_ratio.present?
          begin_ratio = begin_ratio.round(4)
        else
          begin_ratio = 1
        end

        begin_rate = (api_begin_fund_fen_hong.net_worth.dwjz + api_begin_fund_fen_hong.bonus)* begin_ratio / api_begin_net_worth.dwjz


        middle_rate = 1

        # api_end_net_worth.dwjz / 
        api_fund_fen_hongs.each_with_index do |api_fund_fen_hong, index|
          prev_api_fund_fen_hong = api_fund_fen_hongs[index + 1]

          if prev_api_fund_fen_hong.blank?
            break
          end

          middle_ratio = api_fund_chai_fens.where(the_real_break_convert_at: prev_api_fund_fen_hong.the_real_ex_dividend_at..api_fund_fen_hong.the_real_ex_dividend_at).map { |e| e.get_break_ratio_to_f }.map(&:*)

          if middle_ratio.present?
            middle_ratio = middle_ratio.round(4)
          else
            middle_ratio = 1
          end

          middle_rate = middle_rate * (api_fund_fen_hong.net_worth.dwjz + api_fund_fen_hong.bonus) * middle_ratio / prev_api_fund_fen_hong.net_worth.dwjz

        end
        # ...

        yield_rate = ((end_rate * begin_rate * middle_rate - 1) * 100).round(2)

        return {begin_date: begin_date, end_date: end_date,
          yield_rate: yield_rate,
          beginning_day: api_begin_net_worth.record_at, end_day: api_end_net_worth.record_at,
          beginning_net_worth: api_begin_net_worth.dwjz, end_net_worth: api_end_net_worth.dwjz,
          fund_fen_hongs_count: api_fund_fen_hongs.size, fund_chai_fens_count: api_fund_chai_fens.size,
          project_code: self.code}
      end
    end
    # ...
  end


  def yield_type_with_date_range
    yield_hash = {
      'last_one_week' => 1.week,
      'last_one_month' => 1.month,
      'last_two_month' => 2.month,
      'last_three_month' => 3.month,
      'last_six_month' => 6.month,
      'last_one_year' => 1.year,
      'last_two_year' => 2.year,
      'last_three_year' => 3.year,
      'last_five_year' => 5.year,
      'last_seven_year' => 7.year,
      'last_ten_year' => 10.year,
      'since_the_inception' => 100.year
    }
  end


  def yield_type_with_specific
    specific_yield_hash = {
      'this_year' => 1.year.ago.end_of_year
    }
  end

  def set_up_from_yield_type_with_date_range
    yield_type_with_date_range.each_pair do |yield_type, date_range|
      set_up_fund_yields_for(date_range, yield_type)
    end
  end

  def beginning_day_record_at(date_range)
    self.last_trade_net_worth_ago(date_range).record_at
  end

  def beginning_net_worth_dwjz(date_range)
    self.last_trade_net_worth_ago(date_range).dwjz
  end

  def last_trade_net_worth_record_at
    self.last_trade_net_worth.record_at
  end

  def last_trade_net_worth_dwjz
    self.last_trade_net_worth.dwjz
  end

  # 净值变更 7 要素，1 - 开始交易日
  def _beginning_day(date_range)
    beginning_day_record_at(date_range)
  end

  # 净值变更 7 要素，2 - 开始交易净值
  def _beginning_net_worth(date_range)
    beginning_net_worth_dwjz(date_range)
  end

  # 净值变更 7 要素，3 - 结束交易日
  def _end_day()
    self.last_trade_net_worth_record_at
  end

  # 净值变更 7 要素，4 - 结束交易净值
  def _end_net_worth()
    self.last_trade_net_worth_dwjz
  end

  # 净值变更 7 要素，5 - 期间经历拆分次数
  def _fund_chai_fens_count(date_range)
    self.fund_chai_fens_count_from(_beginning_day(date_range), _end_day)
  end

  # 净值变更 7 要素，6 - 期间经历分红次数
  def _fund_fen_hongs_count(date_range)
    self.fund_fen_hongs_count_from(_beginning_day(date_range), _end_day)
  end

  # 净值变更 7 要素，7 - 净值增长率
  def _yield_rate(date_range, yield_type)
    self.target_ranking_ago(date_range)
  end


  def set_up_fund_yields_for(date_range, yield_type)
    _fund_yield = self.fund_yields.find_by(yield_type: yield_type)

    if _fund_yield.present?
      _fund_yield.update(
        beginning_day: _beginning_day(date_range),
        end_day: _end_day,
        beginning_net_worth: _beginning_net_worth(date_range),
        end_net_worth: _end_net_worth,
        fund_chai_fens_count: _fund_chai_fens_count(date_range),
        fund_fen_hongs_count: _fund_fen_hongs_count(date_range),
        yield_rate: _yield_rate(date_range, yield_type))
    else
      self.fund_yields.create(
        beginning_day: _beginning_day(date_range),
        end_day: _end_day,
        beginning_net_worth: _beginning_net_worth(date_range),
        end_net_worth: _end_net_worth,
        fund_chai_fens_count: _fund_chai_fens_count(date_range),
        fund_fen_hongs_count: _fund_fen_hongs_count(date_range),
        yield_rate: _yield_rate(date_range, yield_type),
        yield_type: yield_type)
    end
  end

  def fund_chai_fens_count_from(from_date, to_date)
    _date_range = from_date..to_date

    self.fund_chai_fens.where(break_convert_at: _date_range).size
  end

  def fund_fen_hongs_count_from(from_date, to_date)
    _date_range = from_date..to_date

    self.fund_fen_hongs.where(ex_dividend_at: _date_range).size
  end

  def fund_chai_fens_from(date_range, from_date=nil, to_date=nil)
    _beginning_day = self.last_trade_net_worth_ago(date_range).record_at
    _end_day = self.last_trade_net_worth.record_at

    _date_range = _beginning_day.._end_day

    self.fund_chai_fens.where(break_convert_at: _date_range)
  end

  def fund_fen_hongs_from(date_range, from_date=nil, to_date=nil)
    _beginning_day = self.last_trade_net_worth_ago(date_range).record_at
    _end_day = self.last_trade_net_worth.record_at

    _date_range = _beginning_day.._end_day

    self.fund_fen_hongs.where(ex_dividend_at: _date_range)
  end

  # 距离最后一个交易日（没有限制条件）某段时间 最先的那个交易记录（距离现在最久）
  def last_trade_net_worth_ago(date_range)
    date = last_trade_day.ago(date_range).strftime("%F")

    self.net_worths.order(record_at: :desc).where("record_at >= ?", date).last
  end

  # def last_trade_net_worth_at(date)
  #   self.net_worths.order(record_at: :desc).where("record_at < ?", date).first
  # end

  def target_ranking_ago(date_range, change_to_date=nil)
    if change_to_date.present?
      date = change_to_date.strftime("%F")
      target_net_worth = last_trade_net_worth_ago(date_range)
    else
      date = last_trade_day.ago(date_range).strftime("%F")
      target_net_worth = last_trade_net_worth_ago(date_range)
    end

    if target_net_worth.record_at != date.to_date && change_to_date.blank?
      prev_net_worth = target_net_worth.prev_net_worth

      if prev_net_worth.present?
        target_net_worth = prev_net_worth
      end
    end

    # if target_net_worth.blank?
    #   return
    # end

    _beginning_day = target_net_worth.record_at
    _end_day = last_trade_net_worth.record_at

    _fund_fen_hongs = self.fund_fen_hongs.where(ex_dividend_at: _beginning_day.._end_day).order(ex_dividend_at: :asc)
    _first_fund_fen_hong = _fund_fen_hongs.first

    _fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _beginning_day.._end_day).order(break_convert_at: :asc)
    # _first_fund_chai_fen = _fund_chai_fens.first
    _chai_fen_factor = _fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

    if _chai_fen_factor.present?
      _chai_fen_factor = _chai_fen_factor.round(4)
    else
      _chai_fen_factor = 1
    end


    if _fund_fen_hongs.blank?
      (((last_trade_net_worth.dwjz * _chai_fen_factor) - target_net_worth.dwjz) / target_net_worth.dwjz * 100).round(2)
    elsif _fund_fen_hongs.one?

      end_ratio = last_trade_net_worth.dwjz / _first_fund_fen_hong.dwjz
      begin_ration = (_first_fund_fen_hong.dwjz + _first_fund_fen_hong.bonus) / target_net_worth.dwjz

      # ...
      _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)
      # _first_fund_chai_fen = _fund_chai_fens.first
      _end_chai_fen_factor = _end_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

      if _end_chai_fen_factor.present?
        _end_chai_fen_factor = _end_chai_fen_factor.round(4)
      else
        _end_chai_fen_factor = 1
      end


      ((end_ratio * begin_ration * _end_chai_fen_factor - 1) * 100).round(2)
    else
      # a --> b --> c
   # 　　份额净值增长率=[期末份额净值/(分红日份额净值-分红金额)]×π[期内历次分红当日份额净值/每期期初份额净值]-1(其中，每次分红之间的时间当作一个区间单独计算，然后累乘)。

      # last_trade_net_worth.dwjz/

      _involve_net_worth = self.net_worths.where(record_at: _fund_fen_hongs.pluck(:ex_dividend_at)).order(record_at: :asc)

      # ...
      _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)
      # _first_fund_chai_fen = _fund_chai_fens.first
      _end_chai_fen_factor = _end_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

      if _end_chai_fen_factor.present?
        _end_chai_fen_factor = _end_chai_fen_factor.round(4)
      else
        _end_chai_fen_factor = 1
      end

      end_ratio = last_trade_net_worth.dwjz * _end_chai_fen_factor / _fund_fen_hongs.last.dwjz

      # ...
      _begin_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: target_net_worth.record_at.._first_fund_fen_hong.ex_dividend_at).order(break_convert_at: :asc)
      # _first_fund_chai_fen = _fund_chai_fens.first
      _begin_chai_fen_factor = _begin_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

      if _begin_chai_fen_factor.present?
        _begin_chai_fen_factor = _begin_chai_fen_factor.round(4)
      else
        _begin_chai_fen_factor = 1
      end

      begin_ration = (_first_fund_fen_hong.dwjz + _first_fund_fen_hong.bonus) * _begin_chai_fen_factor / target_net_worth.dwjz

      _x = 1

      _fund_fen_hongs.each_with_index do |_fund_fen_hong, index|
        if index.zero?
          next
        end

        # ...

        # (_fund_fen_hong.dwjz + _fund_fen_hong.bonus) /

        # 2017-02-03  1.1723  1.7623  -0.5%

        # 2016-11-28  1.1785  1.7685  0.25%

        # 2015-11-25  1.2388  1.5888  0.15%

        # 2007-00-00  1       1       0%

        # 年份  权益登记日 除息日 每份分红  分红发放日
        # 2016年 2016-11-28  2016-11-28  每份派现金 0.2400 元  2016-11-30
        # 2015年 2015-11-25  2015-11-25  每份派现金 0.3500 元  2015-11-27

        inner_new_fen_hong = _fund_fen_hong
        inner_old_fen_hong = _fund_fen_hongs[index - 1]

        # ...
        _inner_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: inner_old_fen_hong.ex_dividend_at..inner_new_fen_hong.ex_dividend_at).order(break_convert_at: :asc)
        # _first_fund_chai_fen = _fund_chai_fens.first
        _inner_chai_fen_factor = _inner_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

        if _inner_chai_fen_factor.blank?
          _inner_chai_fen_factor = 1
        end

        _x = _x * ((inner_new_fen_hong.dwjz + inner_new_fen_hong.bonus) * _inner_chai_fen_factor / (inner_old_fen_hong.dwjz))
      end

      # (( ((1.2388 + 0.3500)/1) * ((1.1785 + 0.2400)/1.2388) * (1.1723/1.1785) - 1) * 100).round(2)
      # 80.97
      ((end_ratio * begin_ration * _x - 1) * 100).round(2)
    end
  end

  # 最后一个交易日（没有限制条件）的交易记录
  def last_trade_net_worth
    self.net_worths.order(record_at: :asc).last
  end

  # 最后一个交易日（没有限制条件）
  def last_trade_day
    self.last_trade_net_worth.record_at
  end





  def is_hb_lc?
    self.mold_hb? || self.mold_lc? || self.mold_bb?
  end

  def release_cannot_show?
    self.release_now? || self.release_will? || self.release_not_set?
  end

  # begin last week
  def last_week_trade_day
    self.last_trade_day.weeks_ago(1)
  end

  def last_week_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_week_trade_day).order(record_at: :desc).first
  end

  def last_week_ranking
    return if last_week_trade_day_net_worth.blank?

    ((last_trade_net_worth.dwjz - last_week_trade_day_net_worth.dwjz) / last_week_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last week



  # begin last month
  def last_month_trade_day
    self.last_trade_day.months_ago(1)
  end

  def last_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_month_trade_day).order(record_at: :desc).first
  end

  def last_month_ranking
    return if last_month_trade_day_net_worth.blank?

    ((last_trade_net_worth.dwjz - last_month_trade_day_net_worth.dwjz) / last_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last month

  # begin last three month
  def last_three_month_trade_day
    self.last_trade_day.months_ago(3)
  end

  def last_three_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_three_month_trade_day).order(record_at: :desc).first
  end

  def last_three_month_ranking
    return if last_three_month_trade_day_net_worth.blank?

    ((last_trade_net_worth.dwjz - last_three_month_trade_day_net_worth.dwjz) / last_three_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last three month

  # begin last six month
  def last_six_month_trade_day
    self.last_trade_day.months_ago(6)
  end

  def last_six_month_trade_day_net_worth
    self.net_worths.where("record_at <= ?", last_six_month_trade_day).order(record_at: :desc).first
  end

  def last_six_month_ranking
    return if last_six_month_trade_day_net_worth.blank?

    ((last_trade_net_worth.dwjz - last_six_month_trade_day_net_worth.dwjz) / last_six_month_trade_day_net_worth.dwjz * 100).round(2)
  end
  # end last six month


  def detect_and_set_recommend_at
    if self.today_recommend_changed? && self.today_recommend?
      self.touch :recommend_at

      ::Episode.delay.change_project_list_for(self.id)
    end
  end


  def had_star_by?(user)
    UserStarProject.had_star_by?(self, user)
  end

  def had_recommend_by?(user)
    UserRecommendProject.had_recommend_by?(self, user)
  end




  def to_param
    "#{self.code}-#{self.slug}"
  end

  def show_name
    self.human_name.presence || self.name
  end

  def set_slug
    self.slug = Pinyin.t(self.name, splitter: '-')
  end

  mapping do
    indexes :id, type: :integer

    indexes :name
  end

  def as_indexed_json(options={})
    self.as_json(
      only: [:id, :name],

      include: { catalog: { only: [:name, :slug]}}
    )
  end
end
