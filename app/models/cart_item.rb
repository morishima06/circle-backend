# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :sku

  has_one :product, through: :sku
  belongs_to :cart, touch: true

  def update_quantity(new_quantity)
    update(quantity: new_quantity)  # DBに即反映
  end

  delegate :current_price, to: :product

  delegate :original_price, to: :product

  def subtotal
    quantity * current_price
  end
end
