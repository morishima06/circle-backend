# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :sku
  has_one :reserved_stock, dependent: :destroy

  def subtotal
    price * quantity
  end
end
