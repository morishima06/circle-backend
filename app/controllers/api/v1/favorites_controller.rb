# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < ApplicationController
      def ids
        favorite_ids = current_customer&.favorites&.pluck(:product_id) || []

        render json: {
          favorite_ids:
        }, status: :ok
      end
    end
  end
end
