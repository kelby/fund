# == Schema Information
#
# Table name: fund_chai_fens
#
#  id                        :integer          not null, primary key
#  break_convert_at          :date
#  break_type                :string(255)
#  break_ratio               :string(255)
#  project_id                :integer
#  net_worth_id              :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  the_real_break_convert_at :date
#

class FundChaiFen < ApplicationRecord
  # validates_presence_of :net_worth_id
  validates_presence_of :project_id
  validates_presence_of :break_convert_at, :break_type, :break_ratio

  validates_uniqueness_of :net_worth_id, allow_blank: true
  validates_uniqueness_of :break_convert_at, scope: :project_id


  belongs_to :project, counter_cache: true
  belongs_to :net_worth


  scope :desc, ->{ order(break_convert_at: :desc) }
  scope :asc, ->{ order(break_convert_at: :asc) }


  after_create :set_the_real_break_convert_at_etc


  def set_the_real_break_convert_at_etc
    _net_worth = self.project.net_worths.where("record_at >= ?", self.break_convert_at).asc.first

    if _net_worth.present?
      self.the_real_break_convert_at = _net_worth.record_at
      self.net_worth_id = _net_worth.id
    end

    if self.changed?
      self.save  
    end
  end

  def get_break_ratio_to_f
    if self.break_ratio.split(':').first =~ /\d/
      self.break_ratio.split(':').last.to_f
    else
      1
    end
  end

  def human_break_ratio
    if self.break_ratio.split(':').first =~ /\d/
      self.break_ratio.split(':').last.to_f
    else
      "暂未披露"
    end
  end

  def self.chai_fen_factor
    _chai_fen_factor = self.all.map { |e| e.get_break_ratio_to_f }.inject(&:*)

    if _chai_fen_factor.present?
      _chai_fen_factor = _chai_fen_factor.round(4)
    else
      _chai_fen_factor = 1
    end

    _chai_fen_factor
  end
end
