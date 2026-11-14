# frozen_string_literal: true

module Payments
  class StatusUpdateService
    def self.call(payment, payment_intent)
      new(payment, payment_intent).call
    end

    def initialize(payment, payment_intent)
      @payment = payment
      @payment_intent = payment_intent
    end

    def call
      case @payment_intent.status
      when 'succeeded'
        handle_succeeded
      when 'payment_failed'
        handle_failed
      end
    end

    private

    def handle_succeeded
      @payment.update!(
        status: 'paid'
      )

      @payment.order.confirm!(
        payment: @payment
      )
    end

    def handle_failed
      @payment.update!(
        status: 'failed'
      )
    end
  end
end
