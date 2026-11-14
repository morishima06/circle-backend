# frozen_string_literal: true

# app/services/stripe/create_payment_intent_service.rb
module Stripe
  class CreatePaymentIntentService
    def self.call(order)
      payment_intent = Stripe::PaymentIntent.create(
        amount: order.total,
        currency: 'jpy',
        payment_method_types: ['card'],
        receipt_email: order.email,
        metadata: {
          order_id: order.id,
          number: order.number
        }
      )

      payment = order.payments.create!(
        method: 'card',
        status: 'pending',
        stripe_payment_intent_id: payment_intent.id
      )

      order.update!(current_payment_id: payment.id)

      payment_intent
    end
  end
end
