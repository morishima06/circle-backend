# frozen_string_literal: true

module Api
  module V1
    module Customers
      class FavoritesController < Api::V1::Customers::BaseController
        def index
          favorites = current_customer.favorites
                                      .includes(product: :designer)
                                      .order(created_at: :desc)

          render json: favorites.map do |favorite|
            Api::V1::Customers::Favorites::Serializer.new(favorite).as_json
          end
        end

        def create
          product = Product.find(params[:product_id])

          current_customer.favorites.create!(product:)

          head :created
        end

        def destroy
          favorite = current_customer.favorites.find_by!(product_id: params[:product_id])

          favorite.destroy!

          head :no_content
        end

        def check
          product = Product.find_by!(product_code: params[:product_code])

          favorited = current_customer.favorites.exists?(product_id: product.id)

          render json: { favorited: }
        end
      end
    end
  end
end
