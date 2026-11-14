# frozen_string_literal: true

class Spec < ApplicationRecord
  belongs_to :product

  validates :key, presence: true
  validates :value, presence: true
end
