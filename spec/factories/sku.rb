# frozen_string_literal: true

FactoryBot.define do
  factory :sku do
    association :product
    association :size

    stock { 10 }
    sku_code { "TEST-SKU-#{SecureRandom.hex(4)}" }
  end
end
