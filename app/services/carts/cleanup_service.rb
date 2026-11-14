# frozen_string_literal: true

module Carts
  class CleanupService
    def initialize(order)
      @order = order
    end

    def call
      if @order.guest_token.present?
        Cart.find_by!(guest_token: @order.guest_token).destroy
      else
        Cart.find_by!(customer_id: @order.customer_id).cart_items.destroy_all
      end
    end
  end
end
