# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProductsController < ApplicationController
        include Rails.application.routes.url_helpers

        def index
          products = Product.all

          if params[:keyword].present?
            products = products.where(
              'style_code LIKE :q OR name LIKE :q',
              q: "%#{params[:keyword]}%"
            )
          end

          products = products.order(created_at: :desc)
                             .page(params[:page])
                             .per(params[:per_page])

          render json: {
            products: Api::V1::Admin::Products::Serializer.new(products).as_json,
            pagination: Api::V1::Admin::PaginationSerializer.new(products).as_json
          }
        end

        def show
          product = Product.find(params[:id])

          render json: {
            product: Api::V1::Admin::Products::DetailSerializer.new(product).as_json
          }
        end

        def create
          product = Product.new(
            product_params.except(:images)
          )

          images = product_params[:images]
          product.released_at = Time.current

          ActiveRecord::Base.transaction do
            product.save!

            Admins::ProductImageSyncService.new(
              product:,
              images:
            ).call
          end

          render json: product, status: :created
        end

        def update
          @product = Product.find(params[:id])

          images = product_params[:images] || []

          ActiveRecord::Base.transaction do
            @product.update!(
              product_params.except(:images)
            )

            Admins::ProductImageSyncService.new(
              product: @product,
              images:
            ).call
          end

          render json: @product, status: :ok
        end

        def ship
          order = Order.find(params[:id])
          shipment = order.shipment

          ActiveRecord::Base.transaction do
            order.update!(status: :shipped)

            shipment.update!(
              status: :shipped,
              carrier_name: params[:carrier],
              tracking_number: params[:tracking_number],
              shipped_at: Time.current
            )
          end
          head :no_content
        end

        private

        def product_params
          params.require(:product).permit(
            :name,
            :description,
            :category_id,
            :color_id,
            :designer_id,
            :price,
            :style_code,
            :sale_price,
            :sale_start_at,
            :sale_end_at,
            :status,
            images: %i[
              id
              signed_id
            ],
            skus_attributes: %i[
              id
              size_id
              stock
              _destroy
            ],
            specs_attributes: %i[
              id
              key
              value
              _destroy
            ]
          )
        end
      end
    end
  end
end
