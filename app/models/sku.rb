# frozen_string_literal: true

class Sku < ApplicationRecord
  has_many :reserved_stocks, dependent: :destroy
  has_many :skus, dependent: :restrict_with_error
  belongs_to :product
  belongs_to :size
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items

  validates :stock,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  scope :by_position, -> { joins(:size).order('sizes.position ASC') }

  def available_stock
    stock - reserved_stocks.sum(:quantity)
  end

  def out_of_stock?
    available_stock <= 0
  end
end
