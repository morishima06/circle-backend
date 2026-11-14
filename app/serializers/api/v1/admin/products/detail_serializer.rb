# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Products
        class DetailSerializer
          include Rails.application.routes.url_helpers

          def initialize(product)
            @product = product
          end

          def as_json(*)
            {
              id: @product.id,

              images: @product.product_images.map do |product_image|
                {
                  id: product_image.id,
                  url: url_for(product_image.image),
                  signed_id: product_image.image.signed_id
                }
              end,

              name: @product.name,
              description: @product.description,

              category_name: @product.category.name,
              category_id: @product.category_id,

              designer_name: @product.designer.name,
              designer_id: @product.designer_id,

              color_id: @product.color_id,

              skus: @product.skus.map do |sku|
                {
                  id: sku.id,
                  size_id: sku.size_id,
                  size_label: sku.size.label,
                  stock: sku.stock
                }
              end,

              price: @product.price,
              sale_price: @product.sale_price,
              style_code: @product.style_code,
              status: @product.status,
              on_sale: @product.sale_price.present?,

              specs: @product.specs.map do |spec|
                {
                  id: spec.id,
                  key: spec.key,
                  value: spec.value
                }
              end,

              sale_start_at: @product.sale_start_at,
              sale_end_at: @product.sale_end_at,
              release_at: @product.release_at
            }
          end
        end
      end
    end
  end
end
