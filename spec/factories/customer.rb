# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    email { 'customer@example.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
