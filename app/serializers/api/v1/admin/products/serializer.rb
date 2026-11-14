# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Products
        class Serializer
          include Rails.application.routes.url_helpers

          def initialize(products)
            @products = products
          end

          def as_json(*)
            @products.map do |product|
              first_image = product.product_images.first

              {
                id: product.id,
                image_url: first_image&.image&.attached? ? url_for(first_image.image) : nil,
                style_code: product.style_code,
                designer: product.designer.name,
                name: product.name,
                price: product.price,
                status: product.status,
                created_at: product.created_at
              }
            end
          end
        end
      end
    end
  end
end
