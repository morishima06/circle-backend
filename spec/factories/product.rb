# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    association :category
    association :designer
    association :color

    name { 'テスト商品' }
    price { 50_00 }
    status { 'active' }
    style_code { "TEST-style-#{SecureRandom.hex(4)}" }
  end
end
