# frozen_string_literal: true

class ProductImage < ApplicationRecord
  belongs_to :product, inverse_of: :product_images
  has_one_attached :image

  has_one_attached :image, dependent: :purge
end
