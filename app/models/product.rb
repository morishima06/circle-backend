# frozen_string_literal: true

class Product < ApplicationRecord
  include PgSearch::Model

  before_validation :ensure_style_code
  before_validation :set_style_code_slug

  before_save :set_search_name

  belongs_to :category
  belongs_to :designer
  has_many :skus, dependent: :destroy
  belongs_to :color
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_customers, through: :favorites, source: :customer
  has_many :specs, dependent: :destroy
  has_many :product_images,
           -> { order(:position) },
           inverse_of: :product,
           dependent: :destroy

  accepts_nested_attributes_for :specs,
                                allow_destroy: true,
                                reject_if: :all_blank
  accepts_nested_attributes_for :skus, allow_destroy: true

  pg_search_scope :search,
                  against: :search_name,
                  using: {
                    tsearch: {
                      prefix: true,
                      any_word: false
                    },
                    trigram: {
                      threshold: 0.25
                    }
                  }

  scope :sale, lambda {
    where.not(sale_price: nil)
         .where(
           'sale_start_at <= ? AND sale_end_at >= ?',
           Time.current,
           Time.current
         )
  }

  scope :new_arrivals, -> { where(release_at: 14.days.ago..) }

  scope :by_category, lambda { |category|
    where(category_id: category.subtree_ids)
  }
  scope :by_color, lambda { |color_slug|
    joins(:color).where(colors: { slug: color_slug })
  }
  scope :by_designer, lambda { |designer|
                        where(designer_id: designer.id)
                      }

  scope :by_gender, lambda { |gender|
    where(gender:) if gender.present?
  }

  def on_sale?
    self[:sale_price].present? &&
      sale_start_at.present? &&
      sale_end_at.present? &&
      Time.current.between?(sale_start_at, sale_end_at)
  end

  def active_sale_price
    on_sale? ? self[:sale_price] : nil
  end

  def original_price
    price
  end

  def current_price
    on_sale? ? active_sale_price : price
  end

  def discount_percentage
    return nil unless sale_price.present? && sale_price < price

    ((1 - (sale_price.to_f / price)) * 100).round
  end

  def set_search_name
    text = [
      name,
      designer&.name,
      color&.name
    ].compact.join(' ')

    self.search_name = normalize_for_search(text)
  end

  def normalize_for_search(text)
    text
      .downcase # 大文字小文字無視
      .tr('　', ' ') # 全角スペース → 半角
      .gsub(/[^\p{Alnum}\s]/, '') # 記号削除（. - _ 等）
      .squeeze(' ') # 空白まとめる
      .strip
  end

  # 特定の商品情報を取得するメソッド
  def self.find_with_details(product_code)
    with_color_and_designer.find_by(product_code:)
  end

  def ensure_style_code
    return if style_code.present?

    self.style_code = loop do
      code = SecureRandom.alphanumeric(8).upcase
      break code unless Product.exists?(style_code: code)
    end
  end

  def set_style_code_slug
    return if style_code.blank?

    self.style_code_slug = style_code.parameterize
  end
end
