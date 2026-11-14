# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :customer

  validates :postal_code, :prefecture, :city, :address_line1, presence: true
end
