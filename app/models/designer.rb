# frozen_string_literal: true

class Designer < ApplicationRecord
  include PgSearch::Model
  has_many :products, dependent: :restrict_with_error
  before_validation :set_slug

  validates :slug, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: { prefix: true },
                    trigram: { threshold: 0.25 }
                  }

  BRAND_SLUG_MAP = {
    'A.P.C' => 'apc',
    'C.P. COMPANY' => 'cp-company',
    'C.E' => 'ce'
  }.freeze

  def set_slug
    self.slug ||= generate_slug
  end

  def generate_slug
    BRAND_SLUG_MAP[name] || name.parameterize
  end

  def initial
    first_letter = name[0].upcase
    first_letter.match?(/[A-Z]/) ? first_letter : 'other'
  end

  def self.available_for(params = {})
    # 自分自身で絞り込まない & ソート条件も無視
    filter_params = params.except(:designer, :sort, :page, :per_page)
    joins(:products)
      .merge(Product.filter(filter_params))
      .distinct
      .order(:name)
  end

  # path_nameでデザイナーを検索するクラスメソッド
  def self.find_by_path_name(path_name)
    find_by(slug: path_name)
  end

  # 特定のカテゴリーに属するプロダクトを取得
  def products_by_category(category)
    products.where(category_id: category.subtree_ids)
  end

  # カテゴリーのツリー内のデザイナーを取得
  def self.designers_by_category_tree(category_tree_ids)
    designer_ids = Product.where(category_id: category_tree_ids).pluck(:designer_id).uniq
    where(id: designer_ids)
  end
end
