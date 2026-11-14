# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      def show
        product = Product
                  .includes(:color, :category, :designer, skus: :size)
                  .find_by!(style_code_slug: params[:style_code])

        render json: Api::V1::Products::DetailSerializer.new(product)
      end

      # 商品の閲覧数を増やす API
      def track_product_view
        product = Product.find_by(id: params[:product_id])

        if product
          redis_key = "product:#{product.id}:views"
          view_count = REDIS.incr(redis_key) # Redis のカウントを増やす

          render json: { success: true, views: view_count }, status: :ok
        else
          render json: { error: 'Product not found' }, status: :not_found
        end
      end
    end
  end
end
