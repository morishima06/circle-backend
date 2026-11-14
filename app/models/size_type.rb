# frozen_string_literal: true

class SizeType < ApplicationRecord
  has_many :categories, dependent: :nullify
  has_many :sizes, dependent: :restrict_with_error
end
