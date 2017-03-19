# == Schema Information
#
# Table name: fund_rankings
#
#  id                                    :integer          not null, primary key
#  project_id                            :integer
#  code                                  :string(255)
#  name                                  :string(255)
#  dwjz                                  :decimal(15, 4)
#  three_year_rating                     :integer
#  five_year_rating                      :integer
#  last_week_total_return                :decimal(15, 4)
#  last_week_ranking                     :integer
#  last_month_total_return               :decimal(15, 4)
#  last_month_ranking                    :integer
#  last_three_month_total_return         :decimal(15, 4)
#  last_three_month_ranking              :integer
#  last_six_month_total_return           :decimal(15, 4)
#  last_six_month_ranking                :integer
#  last_year_total_return                :decimal(15, 4)
#  last_year_ranking                     :integer
#  last_two_year_total_return            :decimal(15, 4)
#  last_two_year_ranking                 :integer
#  this_year_total_return                :decimal(15, 4)
#  this_year_ranking                     :integer
#  since_the_inception_total_return      :decimal(15, 4)
#  last_three_year_volatility            :decimal(15, 4)
#  last_three_year_volatility_evaluate   :string(255)
#  last_three_year_risk_factor           :decimal(15, 4)
#  last_three_year_risk_factor_evaluate  :string(255)
#  last_three_year_sharpe_ratio          :decimal(15, 4)
#  last_three_year_sharpe_ratio_evaluate :string(255)
#  record_at                             :date
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  fund_type                             :string(255)
#  evaluate_type                         :string(255)
#  two_year_rating                       :integer
#  one_year_rating                       :integer
#  last_one_year_volatility              :decimal(15, 4)
#  last_one_year_volatility_evaluate     :string(255)
#  last_one_year_risk_factor             :decimal(15, 4)
#  last_one_year_risk_factor_evaluate    :string(255)
#  last_one_year_sharpe_ratio            :decimal(15, 4)
#  last_one_year_sharpe_ratio_evaluate   :string(255)
#  fund_type_classify                    :integer          default("fund_type_unknow")
#

class FundRanking < ApplicationRecord
  # Constants
  FUND_TYPE_SORT_HASH = {"股票型基金" => 3,
    "配置型基金" => 6,
    "债券型基金" => 9,
    "激进配置型基金" => 12,
    "积极配置型基金" => 15,
    "保守配置型基金" => 18,
    "标准混合型基金" => 21,
    "保守混合型基金" => 24,
    "激进债券型基金" => 27,
    "普通债券基金" => 30,
    "短债基金" => 33,
    "保本基金" => 36,
    "货币市场基金" => 39,
    "QDII" => 42}
  # END


  # Associations
  belongs_to :project
  # END


  # Rails class methods
  enum fund_type_classify: { fund_type_unknow: 0,
    gu_piao_xing_ji_jin: 3,
    pei_zhi_xing_ji_jin: 6,
    zhai_quan_xing_ji_jin: 9,
    ji_jin_pei_zhi_xing_ji_jin: 12,
    ji_ji_pei_zhi_xing_ji_jin: 15,
    bao_shou_pei_zhi_xing_ji_jin: 18,
    biao_zhun_hun_he_xing_ji_jin: 21,
    bao_shou_hun_he_xing_ji_jin: 24,
    ji_jin_zhai_quan_xing_ji_jin: 27,
    pu_tong_zhai_quan_ji_jin: 30,
    duan_zhai_ji_jin: 33,
    bao_ben_ji_jin: 36,
    huo_bi_shi_chang_ji_jin: 39,
    qdii: 42}
  # END


  # Validates
  validates_presence_of :code
  validates_presence_of :record_at

  validates_uniqueness_of :record_at, scope: :code
  # END


  # Callbacks
  after_create :set_project_id
  after_create :detect_set_fund_type_classify
  # END


  def set_project_id
    project = Project.find_by(code: self.code)

    if project.present?
      self.update_columns(project_id: project.id)
    end
  end

  def self.max_record_at
    @max_record_at = FundRanking.pluck(:record_at).max
  end

  def self.record_at_years
    @record_at_years = FundRanking.pluck(:record_at).uniq.map{|x| x.strftime("%Y") }.uniq.reverse
  end

  def self.record_at_month_day_by(year_or_date)
    beginning_of_year = year_or_date.beginning_of_year
    end_of_year = year_or_date.end_of_year

    @record_at_years = FundRanking.where(record_at: beginning_of_year..end_of_year).order(record_at: :desc).pluck(:record_at).uniq.map{|x| x.strftime("%m-%d")}
  end

  def format_fund_type
    self.fund_type.gsub(/(^\d{1,99})|(\(\d{1,99}\)$)/, "")
  end

  # ["股票型基金-3", "激进配置型基金-6", "标准混合型基金-9", "积极配置型基金-7", "保守配置型基金-8",
  # "普通债券基金-18", "短债基金-21", "保本基金-24", "货币市场基金-27", "保守混合型基金-12", "激进债券型基金-15",
  # "QDII-30", "配置型基金-4", "债券型基金-5"]
  def self.all_fund_types
    self.pluck(:fund_type).map{|x| x.gsub(/(^\d{1,99})|(\(\d{1,99}\)$)/, "") }.uniq
  end

  def detect_set_fund_type_classify
    if self.fund_type_unknow?
      type_method = Pinyin.t(self.format_fund_type, splitter: "_").downcase

      if FundRanking.fund_type_classifies.keys.include?(type_method)
        # new_method = "#{type_method}!"
        # self.send(new_method)

        self.update_columns(fund_type_classify: FundRanking.fund_type_classifies[type_method])
      end
    end
  end
end
