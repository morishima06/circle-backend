# frozen_string_literal: true

module Api
  module V1
    module Products
      class DetailSerializer
        def initialize(product)
          @product = product
        end

        def as_json(*)
          {
            product: {
              id: @product.id,
              name: @product.name,
              price: @product.price,
              sale_price: @product.sale_price,
              description: @product.description,
              specs: specs_json,
              color: @product.color.name,
              style_code: @product.style_code,
              style_code_slug: @product.style_code_slug,
              designer: designer_json,
              category: category_json,
              skus: sku_json,
              images: images_json
            }
          }
        end

        private

        def designer_json
          return nil unless @product.designer

          {
            id: @product.designer.id,
            name: @product.designer.name,
            slug: @product.designer.slug
          }
        end

        def category_json
          return nil unless @product.category

          {
            id: @product.category.id,
            name: @product.category.name
          }
        end

        def sku_json
          @product.skus.by_position.map do |sku|
            {
              id: sku.id,
              available_stock: sku.available_stock,
              size: sku.size.label
            }
          end
        end

        def images_json
          @product.product_images.filter_map do |product_image|
            next unless product_image.image.attached?

            Rails.application.routes.url_helpers.url_for(
              product_image.image
            )
          end
        end

        def specs_json
          @product.specs.map do |spec|
            {
              id: spec.id,
              key: spec.key,
              value: spec.value
            }
          end
        end
      end
    end
  end
end
