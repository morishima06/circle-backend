# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    order
    status { 'pending' }
    stripe_payment_intent_id { 'pi_test' }

    payment_method { 'card' }
  end
end
