# frozen_string_literal: true

module Api
  module V1
    class CartsController < ApplicationController
      def show
        cart = current_cart

        if cart.nil?
          render json: empty_cart_response, status: :ok
          return
        end

        render json: Api::V1::Carts::Serializer.new(cart), status: :ok
      end

      def cart_item_count
        count = current_cart&.item_count || 0
        render json: { item_count: count }
      end

      private

      def empty_cart_response
        {
          id: nil,
          item_count: 0,
          subtotal: 0,
          shipping_fee: 0,
          total: 0,
          currency: 'JPY',
          items: []
        }
      end
    end
  end
end
