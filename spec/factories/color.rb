# frozen_string_literal: true

FactoryBot.define do
  factory :color do
    slug { "test-color-#{SecureRandom.hex(4)}" }
    name { 'テストカラー' }
    group_slug { 'test-color-group' }
  end
end
