# frozen_string_literal: true

module Stripe
  class UpdatePaymentIntentService
    def self.call(payment_intent_id, order)
      Stripe::PaymentIntent.update(
        payment_intent_id,
        {
          amount: order.total,
          receipt_email: order.email,
          metadata: {
            order_id: order.id,
            number: order.number
          }
        }
      )
    end
  end
end
