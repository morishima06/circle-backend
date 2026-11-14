# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { 'テストカテゴリー' }
    slug { "test-category-#{SecureRandom.hex(4)}" }
  end
end
