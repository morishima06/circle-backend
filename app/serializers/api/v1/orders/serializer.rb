# frozen_string_literal: true

module Api
  module V1
    module Orders
      class Serializer
        def initialize(order)
          @order = order
        end

        def as_json(*)
          first_item = @order.order_items.first

          {
            id: @order.id,
            number: @order.number,
            status: @order.status,
            ordered_at: @order.ordered_at,
            items_count: @order.items_count,
            subtotal: @order.calculated_subtotal,
            total: @order.calculated_total,
            image_url: image_url(first_item)
          }
        end

        private

        def image_url(order_item)
          return unless order_item

          product_image = order_item.sku.product.product_images.first
          return unless product_image&.image&.attached?

          Rails.application.routes.url_helpers.url_for(
            product_image.image
          )
        end
      end
    end
  end
end
