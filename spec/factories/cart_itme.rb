# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    association :cart
    association :sku
    quantity { 1 }
    price { sku.product.current_price }
  end
end
