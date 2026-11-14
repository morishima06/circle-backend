# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Orders
        class DetailSerializer
          def initialize(order)
            @order = order
          end

          def as_json(*)
            {
              email: @order.email,
              number: @order.number,
              status: @order.status,
              selected_address_id: @order.selected_address_id,
              shipping: shipping_json,
              items: order_items_json,
              subtotal: @order.calculated_subtotal,
              shipping_fee: @order.calculated_shipping_fee,
              total: @order.calculated_total
            }
          end

          private

          def shipping_json
            {
              last_name: @order.last_name,
              first_name: @order.first_name,
              postal_code: @order.postal_code,
              prefecture: @order.prefecture,
              city: @order.city,
              address_line1: @order.address_line1,
              address_line2: @order.address_line2,
              phone_number: @order.phone_number
            }
          end

          def order_items_json
            @order.order_items.map do |item|
              product_image = item.sku.product.product_images.first

              {
                id: item.id,
                sku_id: item.sku_id,
                quantity: item.quantity,
                name: item.name,
                color: item.color,
                designer: item.designer,
                size: item.size,
                unit_price: item.price,
                original_price: item.original_price,
                image_url: image_url(product_image)
              }
            end
          end

          def image_url(product_image)
            return nil unless product_image&.image&.attached?

            Rails.application.routes.url_helpers.url_for(
              product_image.image
            )
          end
        end
      end
    end
  end
end
