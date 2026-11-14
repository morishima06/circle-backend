# frozen_string_literal: true

class ReservedStock < ApplicationRecord
  belongs_to :sku
  belongs_to :order_item
end
