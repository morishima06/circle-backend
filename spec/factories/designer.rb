# frozen_string_literal: true

FactoryBot.define do
  factory :designer do
    name { 'テストデザイナー' }
    slug { "test-designer-#{SecureRandom.hex(4)}" }
  end
end
