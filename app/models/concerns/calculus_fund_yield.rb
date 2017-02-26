module CalculusFundYield
  module ClassMethods
  end

  module InstanceMethods
    # ======================= 第一梯队 =======================
    # 第 1 个方法，第一入口
    def set_up_from_yield_type_with_date_range
      yield_type_with_date_range.each_pair do |yield_type, date_range|
        set_up_fund_yields_for(date_range, yield_type)
      end
    end

    # 第 2 个方法
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

    # 第 3 个方法
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

    # ===================== 第二梯队 ===========================

    # 净值变更 7 要素，1 - 开始交易日
    def _beginning_day(date_range)
      beginning_day_record_at(date_range)
    end

    # 净值变更 7 要素，3 - 结束交易日
    def _end_day()
      self.last_trade_net_worth_record_at
    end

    # 净值变更 7 要素，2 - 开始交易净值
    def _beginning_net_worth(date_range)
      beginning_net_worth_dwjz(date_range)
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

    # ================== 第三梯队 ==============================

    def beginning_day_record_at(date_range)
      self.last_trade_net_worth_ago(date_range).record_at
    end

    def last_trade_net_worth_record_at
      self.last_trade_net_worth.record_at
    end

    def beginning_net_worth_dwjz(date_range)
      self.last_trade_net_worth_ago(date_range).dwjz
    end

    def last_trade_net_worth_dwjz
      self.last_trade_net_worth.dwjz
    end

    def fund_chai_fens_count_from(from_date, to_date)
      _date_range = from_date..to_date

      self.fund_chai_fens.where(break_convert_at: _date_range).size
    end

    def fund_fen_hongs_count_from(from_date, to_date)
      _date_range = from_date..to_date

      self.fund_fen_hongs.where(ex_dividend_at: _date_range).size
    end

    # ================== 第三梯队，核心 ==========================

    def target_ranking_ago(date_range)
      date = last_trade_day.ago(date_range).strftime("%F")


      target_net_worth = last_trade_net_worth_ago(date_range)

      if target_net_worth.record_at != date.to_date
        prev_net_worth = target_net_worth.prev_net_worth

        if prev_net_worth.present?
          target_net_worth = prev_net_worth
        end
      end


      _beginning_day = target_net_worth.record_at
      _end_day = last_trade_net_worth.record_at


      _fund_fen_hongs = self.fund_fen_hongs.where(ex_dividend_at: _beginning_day.._end_day).order(ex_dividend_at: :asc)
      _first_fund_fen_hong = _fund_fen_hongs.first


      _fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _beginning_day.._end_day).order(break_convert_at: :asc)

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

        _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)

        _end_chai_fen_factor = _end_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

        if _end_chai_fen_factor.present?
          _end_chai_fen_factor = _end_chai_fen_factor.round(4)
        else
          _end_chai_fen_factor = 1
        end


        ((end_ratio * begin_ration * _end_chai_fen_factor - 1) * 100).round(2)
      else
        # 份额净值增长率=[期末份额净值/(分红日份额净值-分红金额)]×π[期内历次分红当日份额净值/每期期初份额净值]-1(其中，每次分红之间的时间当作一个区间单独计算，然后累乘)。

        _involve_net_worth = self.net_worths.where(record_at: _fund_fen_hongs.pluck(:ex_dividend_at)).order(record_at: :asc)

        _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)

        _end_chai_fen_factor = _end_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

        if _end_chai_fen_factor.present?
          _end_chai_fen_factor = _end_chai_fen_factor.round(4)
        else
          _end_chai_fen_factor = 1
        end

        end_ratio = last_trade_net_worth.dwjz * _end_chai_fen_factor / _fund_fen_hongs.last.dwjz


        _begin_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: target_net_worth.record_at.._first_fund_fen_hong.ex_dividend_at).order(break_convert_at: :asc)

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

          inner_new_fen_hong = _fund_fen_hong
          inner_old_fen_hong = _fund_fen_hongs[index - 1]


          _inner_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: inner_old_fen_hong.ex_dividend_at..inner_new_fen_hong.ex_dividend_at).order(break_convert_at: :asc)

          _inner_chai_fen_factor = _inner_fund_chai_fens.map { |e| e.get_break_ratio_to_f }.inject(&:*)

          if _inner_chai_fen_factor.blank?
            _inner_chai_fen_factor = 1
          end

          _x = _x * ((inner_new_fen_hong.dwjz + inner_new_fen_hong.bonus) * _inner_chai_fen_factor / (inner_old_fen_hong.dwjz))
        end

        ((end_ratio * begin_ration * _x - 1) * 100).round(2)
      end
    end

    # ================== 第四梯队 ==============================

    # 距离最后一个交易日（没有限制条件）某段时间 最先的那个交易记录（距离现在最久）
    def last_trade_net_worth_ago(date_range)
      date = last_trade_day.ago(date_range).strftime("%F")

      self.net_worths.order(record_at: :desc).where("record_at >= ?", date).last
    end

    # 最后一个交易日（没有限制条件）的交易记录
    def last_trade_net_worth
      self.net_worths.order(record_at: :asc).last
    end

    # 最后一个交易日（没有限制条件）
    def last_trade_day
      self.last_trade_net_worth.record_at
    end

  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end