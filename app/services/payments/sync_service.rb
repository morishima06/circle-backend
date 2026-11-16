# frozen_string_literal: true

module Payments
  class SyncService
    def self.call(payment)
      new(payment).call
    end

    def initialize(payment)
      @payment = payment
    end

    def call
      payment_intent = Stripe::PaymentIntent.retrieve(
        payment.stripe_payment_intent_id
      )

      Rails.logger.debug payment_intent.status

      payment.with_lock do
        payment.reload

        case payment_intent.status
        when 'succeeded'
          payment.update!(status: :succeeded)

        when 'requires_payment_method'
          payment.update!(status: :failed)

        when 'canceled'
          payment.update!(status: :canceled)

        when 'processing'
          # pendingのまま
        end
      end
    end

    private

    attr_reader :payment
  end
end
