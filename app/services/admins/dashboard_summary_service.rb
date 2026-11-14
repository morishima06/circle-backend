# frozen_string_literal: true

module Admins
  class DashboardSummaryService
    def call
      {
        order_tasks:,
        sales_summary:
      }
    end

    private

    def order_tasks
      {
        awaiting_shipment: Order.awaiting_shipment.count,
        payment_pending: Payment.pending_bank_transfer.count,
        on_hold: Order.on_hold.count
      }
    end

    def sales_summary
      {
        this_month: summary_for(Time.current.all_month),
        today: summary_for(Time.current.all_day),
        yesterday: summary_for(1.day.ago.all_day)
      }
    end

    def summary_for(range)
      orders = Order.where(ordered_at: range)

      {
        amount: orders.sum(:total),
        count: orders.count
      }
    end
  end
end
