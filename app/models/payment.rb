# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :order

  scope :pending_bank_transfer, lambda {
    where(
      payment_method: 'bank_transfer',
      status: 'pending'
    )
  }

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def cancel!
    Stripe::PaymentIntent.cancel(stripe_payment_intent_id) if method == 'card' && stripe_payment_intent_id.present?

    update!(status: :cancelled)
  end

  def cancelable?
    status == 'pending'
  end
end
