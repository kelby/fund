# == Schema Information
#
# Table name: fund_fen_hongs
#
#  id                       :integer          not null, primary key
#  register_at              :date
#  ex_dividend_at           :date
#  bonus_per                :string(255)
#  dividend_distribution_at :date
#  project_id               :integer
#  net_worth_id             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  bonus                    :decimal(15, 4)
#  the_real_ex_dividend_at  :date
#

class FundFenHong < ApplicationRecord
  # validates_presence_of :net_worth_id # 实际情况，不是完全对应

  validates_presence_of :project_id
  validates_presence_of :register_at, :ex_dividend_at

  validates_presence_of :bonus_per, if: Proc.new{|fund_fen_hong| fund_fen_hong.bonus.blank?}
  validates_presence_of :bonus, if: Proc.new{|fund_fen_hong| fund_fen_hong.bonus_per.blank?}

  validates_uniqueness_of :net_worth_id, allow_blank: true
  validates_uniqueness_of :ex_dividend_at, scope: :project_id
  validates_uniqueness_of :register_at, scope: :project_id


  belongs_to :project, counter_cache: true
  belongs_to :net_worth


  before_validation :detect_set_bonus_per
  before_validation :detect_set_bonus

  after_create :set_the_real_ex_dividend_at_etc


  scope :desc, ->{ order(ex_dividend_at: :desc) }
  scope :asc, ->{ order(ex_dividend_at: :asc) }
  scope :have_net_worth, -> { where.not(net_worth_id: nil) }


  def set_the_real_ex_dividend_at_etc
    _net_worth = self.project.net_worths.where("record_at >= ?", self.ex_dividend_at).asc.first

    if _net_worth.present?
      self.the_real_ex_dividend_at = _net_worth.record_at
      self.net_worth_id = _net_worth.id
    end

    if self.changed?
      self.save
    end
  end

  def detect_set_bonus_per
    if bonus_per.blank? && bonus.present?
      self.bonus_per = "每份派现金#{self.bonus}元"
    end
  end

  def detect_set_bonus
    if bonus_per.present? && bonus.blank?
      self.bonus = self.bonus_per.gsub(/^每份派现金/, "").gsub(/元$/, "").to_f
    end
  end

  # 实际情况，不是完全对应
  def dwjz
    # self.project.net_worths.where("record_at >= ?", self.ex_dividend_at).order(record_at: :asc).first.try(:dwjz)
    self.net_worth.dwjz
  end
end
