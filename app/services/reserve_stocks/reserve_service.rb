# frozen_string_literal: true

module ReserveStocks
  class ReserveService
    def initialize(order)
      @order = order
      @expires_at = 30.minutes.from_now
    end

    def call
      @order.order_items.sort_by(&:sku_id).each do |item|
        existing_reservation = ReservedStock.find_by(
          order_item: item
        )

        # 既存予約が有効なら、そのまま利用
        next if existing_reservation&.expires_at&.future?

        # 既存予約が期限切れなら削除
        existing_reservation&.destroy!

        sku = Sku.lock.find(item.sku_id)

        available_quantity = sku.available_stock

        # 在庫不足
        if item.quantity > available_quantity
          raise BusinessError.new(
            'out_of_stock',
            'XXの在庫が不足しています'
          )
        end

        # 新しく在庫予約
        ReservedStock.create!(
          order_item: item,
          sku:,
          quantity: item.quantity,
          expires_at: @expires_at
        )
      end
    end
  end
end
