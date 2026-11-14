# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Favorites
        class Serializer
          include Rails.application.routes.url_helpers

          def initialize(favorite)
            @favorite = favorite
          end

          def as_json(*)
            {
              id: @favorite.id,
              product: {
                id: @favorite.product.id,
                name: @favorite.product.name,
                price: @favorite.product.price,
                image_url: (url_for(@favorite.product.images.first) if @favorite.product.images.attached?),
                designer: {
                  id: @favorite.product.designer.id,
                  name: @favorite.product.designer.name
                }
              },
              created_at: @favorite.created_at
            }
          end
        end
      end
    end
  end
end
