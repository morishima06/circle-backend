# frozen_string_literal: true

module Admins
  class DashboardChartService
    def initialize(period:)
      @period = period
    end

    def call
      case @period
      when 'weekly'
        daily_chart(7)
      when 'monthly'
        daily_chart(30)
      when 'yearly'
        monthly_chart(12)
      end
    end

    private

    def daily_chart(days)
      (days - 1).days.ago.to_date.upto(Date.current).map do |date|
        {
          label: date.strftime('%m/%d'),
          amount: Order.ordered_between(date.all_day).sum(:total)
        }
      end
    end

    def monthly_chart(months)
      (months - 1).downto(0).map do |i|
        date = i.months.ago

        {
          label: date.strftime('%Y/%m'),
          amount: Order.ordered_between(date.all_month).sum(:total)
        }
      end
    end
  end
end
