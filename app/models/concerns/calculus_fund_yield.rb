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
      fund_yield = self.fund_yields.find_by(yield_type: yield_type)

      if fund_yield.present?
        fund_yield.update(
          beginning_day: time_ago_begin_trade_record_at(date_range),
          end_day: last_trade_record_at,
          beginning_net_worth: time_ago_begin_trade_dwjz(date_range),
          end_net_worth: last_trade_dwjz,
          fund_chai_fens_count: valid_fund_chai_fens_count(date_range),
          fund_fen_hongs_count: valid_fund_fen_hongs_count(date_range),
          yield_rate: target_ranking_ago(date_range))
      else
        self.fund_yields.create(
          beginning_day: time_ago_begin_trade_record_at(date_range),
          end_day: last_trade_record_at,
          beginning_net_worth: time_ago_begin_trade_dwjz(date_range),
          end_net_worth: last_trade_dwjz,
          fund_chai_fens_count: valid_fund_chai_fens_count(date_range),
          fund_fen_hongs_count: valid_fund_fen_hongs_count(date_range),
          yield_rate: target_ranking_ago(date_range),
          yield_type: yield_type)
      end
    end

    # ===================== 第二梯队 ===========================

    # 净值变更 7 要素，1 - 开始交易日
    # def _time_ago_beginning_day(date_range)
    #   beginning_day_record_at(date_range)
    # end

    # 净值变更 7 要素，3 - 结束交易日
    # def _end_day()
    #   self.last_trade_net_worth_record_at
    # end

    # 净值变更 7 要素，2 - 开始交易净值
    # def _beginning_net_worth(date_range)
    #   time_ago_begin_trade_dwjz(date_range)
    # end

    # 净值变更 7 要素，4 - 结束交易净值
    # def _end_net_worth()
    #   self.last_trade_net_worth_dwjz
    # end

    # 净值变更 7 要素，5 - 期间经历拆分次数
    def valid_fund_chai_fens_count(date_range)
      self.fund_chai_fens_count_from(time_ago_begin_trade_record_at(date_range), last_trade_record_at)
    end



    # 净值变更 7 要素，6 - 期间经历分红次数
    def valid_fund_fen_hongs_count(date_range)
      self.fund_fen_hongs_count_from(time_ago_begin_trade_record_at(date_range), last_trade_record_at)
    end



    # 净值变更 7 要素，7 - 净值增长率
    # def _yield_rate(date_range)
    #   self.target_ranking_ago(date_range)
    # end

    # ================== 第三梯队 ==============================

    # def last_trade_net_worth_record_at
    #   self.last_trade_net_worth.record_at
    # end




    # def beginning_day_record_at(date_range)
    #   self.time_ago_begin_trade_net_worth(date_range).record_at
    # end

    def valid_fund_chai_fens(date_range)
      self.fund_chai_fens.where(the_real_break_convert_at: time_ago_begin_trade_record_at(date_range)..last_trade_record_at)
    end

    # 净值变更 7 要素，6 - 期间经历分红次数
    def valid_fund_fen_hongs(date_range)
      self.fund_fen_hongs.have_net_worth.where(the_real_ex_dividend_at: time_ago_begin_trade_record_at(date_range)..last_trade_record_at)
    end

    def fund_chai_fens_count_from(from_date, to_date)
      _date_range = from_date..to_date

      self.fund_chai_fens.where(the_real_break_convert_at: _date_range).size
    end

    def fund_fen_hongs_count_from(from_date, to_date)
      _date_range = from_date..to_date

      self.fund_fen_hongs.have_net_worth.where(the_real_ex_dividend_at: _date_range).size
    end

    # ================== 第三梯队，核心 ==========================

    def target_ranking_ago(date_range)
      # date = last_trade_record_at.ago(date_range).strftime("%F")


      # target_net_worth = time_ago_begin_trade_net_worth(date_range)

      # if target_net_worth.record_at != date.to_date
      #   prev_net_worth = target_net_worth.prev_net_worth

      #   if prev_net_worth.present?
      #     target_net_worth = prev_net_worth
      #   end
      # end


      # _beginning_day = target_net_worth.record_at
      # _end_day = last_trade_net_worth.record_at


      # fund_fen_hongs = self.valid_fund_fen_hongs(date_range).order(ex_dividend_at: :asc)
      # first_fund_fen_hong = fund_fen_hongs.first


      # fund_chai_fens = self.valid_fund_chai_fens(date_range).order(break_convert_at: :asc)



      if valid_fund_fen_hongs(date_range).blank?
        chai_fen_factor = valid_fund_chai_fens(date_range).chai_fen_factor

        (((last_trade_dwjz * chai_fen_factor) - time_ago_begin_trade_dwjz(date_range)) / time_ago_begin_trade_dwjz(date_range) * 100).round(2)

      elsif valid_fund_fen_hongs(date_range).one?
        first_fund_fen_hong = valid_fund_fen_hongs(date_range).asc.first

        end_ratio = last_trade_dwjz / first_fund_fen_hong.dwjz
        begin_ration = (first_fund_fen_hong.dwjz + first_fund_fen_hong.bonus) / time_ago_begin_trade_dwjz(date_range)

        chai_fen_factor = valid_fund_chai_fens(date_range).chai_fen_factor

        # 分析后发现都是乘除 chai_fen_factor 放的位置无所谓
        ((end_ratio * begin_ration * chai_fen_factor - 1) * 100).round(2)
      else
        first_fund_fen_hong = valid_fund_fen_hongs(date_range).asc.first
        # 份额净值增长率=[期末份额净值/(分红日份额净值-分红金额)]×π[期内历次分红当日份额净值/每期期初份额净值]-1(其中，每次分红之间的时间当作一个区间单独计算，然后累乘)。

        # _involve_net_worth = self.net_worths.where(record_at: _fund_fen_hongs.pluck(:ex_dividend_at)).order(record_at: :asc)

        # _end_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: _fund_fen_hongs.last.ex_dividend_at..last_trade_net_worth.record_at).order(break_convert_at: :asc)

        # _end_chai_fen_factor = _end_fund_chai_fens.chai_fen_factor

        end_ratio = last_trade_dwjz / valid_fund_fen_hongs(date_range).desc.first.dwjz


        # _begin_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: target_net_worth.record_at..first_fund_fen_hong.ex_dividend_at).order(break_convert_at: :asc)

        # _begin_chai_fen_factor = _begin_fund_chai_fens.chai_fen_factor


        begin_ration = (first_fund_fen_hong.dwjz + first_fund_fen_hong.bonus) / time_ago_begin_trade_dwjz(date_range)

        _x = 1

        valid_fund_fen_hongs(date_range).desc.each_with_index do |_fund_fen_hong, index|
          # if index.zero?
          #   next
          # end

          inner_new_fen_hong = _fund_fen_hong
          inner_old_fen_hong = valid_fund_fen_hongs(date_range).desc[index + 1]

          if inner_old_fen_hong.blank?
            break
          end


          # _inner_fund_chai_fens = self.fund_chai_fens.where(break_convert_at: inner_old_fen_hong.ex_dividend_at..inner_new_fen_hong.ex_dividend_at).order(break_convert_at: :asc)

          # _inner_chai_fen_factor = _inner_fund_chai_fens.chai_fen_factor



          _x = _x * ((inner_new_fen_hong.dwjz + inner_new_fen_hong.bonus) / (inner_old_fen_hong.dwjz))
        end

        chai_fen_factor = valid_fund_chai_fens(date_range).chai_fen_factor

        ((end_ratio * begin_ration * _x * chai_fen_factor - 1) * 100).round(2)
      end
    end
    alias :_yield_rate :target_ranking_ago

    # ================== 第四梯队 ==============================

    # 距离最后一个交易日（没有限制条件）某段时间 最先的那个交易记录（距离现在最久）
    def time_ago_begin_trade_net_worth(date_range)
      date = last_trade_record_at.ago(date_range).strftime("%F")

      # self.net_worths.desc.where("record_at >= ?", date).last

      # 1) 当天是交易日，直接获取
      # 2) 当天不是交易日，取上一个交易日 (小于、从大到小、第一个)
      _net_worth = self.net_worths.where("record_at <= ?", date).desc.first

      if _net_worth.blank?
        # 3) 开始时间太早，还没有交易数据，取首个交易日
        _net_worth = self.net_worths.asc.first
      end

      _net_worth
    end

    # 时间段内，首个交易，如果当天没有交易会提取前一个交易日。如果太早了，会取首个交易日
    def time_ago_begin_trade_record_at(date_range)
      time_ago_begin_trade_net_worth(date_range).record_at
    end
    alias :beginning_day_record_at :time_ago_begin_trade_record_at
    alias :_time_ago_beginning_day :time_ago_begin_trade_record_at

    # 开始交易日的净值
    def time_ago_begin_trade_dwjz(date_range)
      self.time_ago_begin_trade_net_worth(date_range).dwjz
    end
    alias :_beginning_net_worth :time_ago_begin_trade_dwjz

    # -------------------------------------------------------

    # 最后一个交易日（没有限制条件）的交易记录
    def last_trade_net_worth
      self.net_worths.desc.first
    end

    # 最后一个交易日（没有限制条件）
    def last_trade_record_at
      self.last_trade_net_worth.record_at
    end
    alias :last_trade_net_worth_record_at :last_trade_record_at
    alias :_end_day :last_trade_record_at

    def last_trade_dwjz
      self.last_trade_net_worth.dwjz
    end
    alias :last_trade_net_worth_dwjz :last_trade_dwjz
    alias :_end_net_worth :last_trade_dwjz

    # -------------------------------------------------------

    def valid_date_range(date_range)
      time_ago_begin_trade_record_at(date_range)..last_trade_record_at
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end