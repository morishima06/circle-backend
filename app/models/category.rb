# frozen_string_literal: true

class Category < ApplicationRecord
  has_ancestry
  has_many :products, dependent: :restrict_with_error
  belongs_to :size_type, optional: true

  before_validation :set_slug, on: :create

  validates :slug, presence: true, uniqueness: true

  def self.available_for(params = {}, allowed_ids = nil)
    filter_params = params.except(:category, :sort, :page, :per_page)

    categories = joins(:products)
                 .merge(Product.filter(filter_params))
                 .distinct
                 .order(:name)

    categories = categories.where(id: allowed_ids) if allowed_ids.present?

    all_ids = (categories.map(&:id) + categories.map(&:ancestor_ids).flatten.compact).uniq
    where(id: all_ids).order(:name)
  end

  def set_slug
    self.slug ||= name.parameterize
  end
end
