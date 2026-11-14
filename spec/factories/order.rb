# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    customer { nil }
    email { customer&.email }
    status { 'pending' }
    expires_at { 30.minutes.from_now }
  end
end
