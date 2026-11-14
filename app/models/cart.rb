# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :cart_items,
           -> { order(:id) },
           inverse_of: :cart,
           dependent: :destroy
  has_many :skus, through: :cart_items, dependent: :destroy
  delegate :empty?, to: :cart_items

  CART_EXPIRATION = 30.days

  def expired?
    updated_at < CART_EXPIRATION.ago
  end

  def item_count
    cart_items.sum(:quantity)
  end

  # 商品合計
  def subtotal
    cart_items.sum(&:subtotal)
  end

  def shipping_fee
    subtotal >= Pricing::FREE_SHIPPING_THRESHOLD ? 0 : Pricing::SHIPPING_FEE
  end

  # 合計金額
  def total
    subtotal + shipping_fee
  end

  def add_item(sku, quantity)
    product_name = sku.product.name
    size_label = sku.size.label

    # 先に既存アイテムを取得
    cart_item = cart_items.find_or_initialize_by(sku:)
    total_quantity = cart_item.quantity.to_i + quantity

    # 合計で在庫チェック
    if total_quantity > sku.available_stock
      raise BusinessError.new('out_of_stock',
                              "『#{product_name}（#{size_label}）』はこれ以上追加できません")
    end

    # チェック通過後に保存
    cart_item.quantity = total_quantity
    cart_item.price = sku.product.current_price if cart_item.new_record?
    cart_item.save!
  end

  def update_item(sku, quantity)
    item = cart_items.find_by!(sku_id: sku.id)
    product_name = sku.product.name
    size_label = sku.size.label

    if quantity > sku.available_stock
      raise BusinessError.new('out_of_stock',
                              "『#{product_name}（#{size_label}）』はこれ以上追加できません")
    end

    item.update!(quantity:)
  end

  def remove_item(sku)
    item = cart_items.find_by!(sku_id: sku.id)

    item.destroy! # DB 上のレコードを削除
  end
end
