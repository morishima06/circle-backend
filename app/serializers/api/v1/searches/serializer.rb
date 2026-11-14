# frozen_string_literal: true

module Api
  module V1
    module Searches
      class Serializer
        def initialize(products)
          @products = products
        end

        def as_json
          @products.map do |product|
            {
              id: product.id,
              name: product.name,
              price: product.current_price,
              original_price: product.original_price,
              sale_price: product.active_sale_price,
              image_url: product.product_images.first&.image&.url,
              gender: product.gender,
              designer: {
                name: product.designer.name,
                slug: product.designer.slug
              },
              style_code_slug: product.style_code_slug
            }
          end
        end
      end
    end
  end
end
