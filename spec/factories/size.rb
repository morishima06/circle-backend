# frozen_string_literal: true

FactoryBot.define do
  factory :size do
    association :size_type

    label { 'M' }
    position { 1 }
  end
end
