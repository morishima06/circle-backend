# frozen_string_literal: true

class Size < ApplicationRecord
  belongs_to :size_type
  has_many :skus, dependent: :restrict_with_error
end
