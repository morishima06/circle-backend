# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    order
    sku
    quantity { 1 }

    name { sku.product.name }
    color { sku.product.color.name }
    designer { sku.product.designer.name }
    size { sku.size.label }
    price { sku.product.current_price }
    original_price { sku.product.price }
  end
end
