# frozen_string_literal: true

module Api
  module V1
    module Carts
      class Serializer
        include Rails.application.routes.url_helpers

        def initialize(cart)
          @cart = cart
        end

        def as_json(*)
          {
            id: @cart.id,
            item_count: @cart.item_count,
            subtotal: @cart.subtotal,
            shipping_fee: @cart.shipping_fee,
            total: @cart.total,
            currency: 'JPY',
            items: @cart.cart_items.map { |item| serialize_item(item) }
          }
        end

        private

        def serialize_item(item)
          {
            id: item.id,
            quantity: item.quantity,
            color: {
              name: item.sku.product.color.name
            },
            product: {
              name: item.product.name,
              gender: item.product.gender,
              image_url: image_url(item.product),
              style_code: item.product.style_code,
              style_code_slug: item.product.style_code_slug,
              designer: {
                name: item.product.designer.name,
                slug: item.product.designer.slug
              }
            },
            sku: {
              id: item.sku.id,
              size: item.sku.size.label,
              available_stock: item.sku.available_stock
            },
            price: {
              original_price: item.original_price,
              unit_price: item.price,
              line_total: item.subtotal
            }
          }
        end

        def image_url(product)
          product_image = product.product_images.first

          return nil unless product_image&.image&.attached?

          url_for(product_image.image)
        end
      end
    end
  end
end
