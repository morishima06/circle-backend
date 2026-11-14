# frozen_string_literal: true

module Api
  module V1
    module Orders
      class CompleteSerializer
        def initialize(order)
          @order = order
        end

        def as_json(*)
          {
            status: @order.status,
            number: @order.number,
            confirmed_at: @order.ordered_at,
            payment_method: @order.current_payment.payment_method
          }
        end
      end
    end
  end
end
