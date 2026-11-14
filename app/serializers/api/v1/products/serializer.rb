# frozen_string_literal: true

module Api
  module V1
    module Products
      class Serializer
        def initialize(products, gender:)
          @products = products
          @gender = gender
        end

        def as_json(*)
          @products.map do |product|
            serialize_product(product)
          end
        end

        private

        def serialize_product(product)
          {
            id: product.id,
            name: product.name,
            original_price: product.price,
            sale_price: product.sale_price,
            image_url: image_url(product),
            designer: {
              id: product.designer.id,
              name: product.designer.name,
              slug: product.designer.slug
            },
            url: "/#{@gender}/p/#{product.designer.slug}/#{product.style_code_slug}"
          }
        end

        def image_url(product)
          product_image = product.product_images.first

          return unless product_image&.image&.attached?

          Rails.application.routes.url_helpers.url_for(
            product_image.image.variant(
              resize_to_limit: [500, 500]
            )
          )
        end
      end
    end
  end
end
