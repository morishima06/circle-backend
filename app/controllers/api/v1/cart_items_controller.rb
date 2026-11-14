# frozen_string_literal: true

module Api
  module V1
    class CartItemsController < ApplicationController
      def create
        sku = Sku.find(params[:sku_id])
        quantity = params[:quantity].to_i
        cart = current_cart || create_cart!
        cart.add_item(sku, quantity)
        extend_guest_token_expiry
        head :ok
      end

      def update
        cart = current_cart
        sku = Sku.find(params[:sku_id])
        cart.update_item(sku, params[:quantity].to_i)
        extend_guest_token_expiry
        head :no_content
      end

      def destroy
        cart = current_cart
        sku = Sku.find(params[:sku_id])
        cart.remove_item(sku)
        extend_guest_token_expiry
        head :no_content
      end
    end
  end
end
