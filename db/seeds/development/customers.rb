# frozen_string_literal: true

require 'faker'

Faker::Config.locale = :ja

statuses = %w[
  active
  suspended
  banned
  withdrawn
]

# ── Customer生成 ──────────────────────────────────
30.times.map do
  Customer.create!(
    email: "#{SecureRandom.hex(4)}@example.com",
    password: 'password123',
    last_name: Faker::Name.last_name,
    first_name: Faker::Name.first_name,
    phone_number: Faker::PhoneNumber.cell_phone,
    status: statuses.sample
  )
end

# ログイン確認用
# ── Test Customer ────────────────────────────────

test_customers = [
  {
    email: 'test1@example.com',
    password: 'password123',
    last_name: 'テスト',
    first_name: 'ユーザー1',
    last_name_kana: 'テスト',
    first_name_kana: 'ユーザーワン',
    phone_number: '09012345678',
    status: 'active'
  },
  {
    email: 'test2@example.com',
    password: 'password123',
    last_name: 'テスト',
    first_name: 'ユーザー2',
    last_name_kana: 'テスト',
    first_name_kana: 'ユーザーツー',
    phone_number: '09087654321',
    status: 'active'
  }
]

test_customers.each do |attributes|
  Customer.find_or_initialize_by(email: attributes[:email]).tap do |customer|
    customer.assign_attributes(attributes)
    customer.password_confirmation = attributes[:password]
    customer.save!
  end
end
