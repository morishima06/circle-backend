# frozen_string_literal: true

module Carts
  class MergeGuestCartService
    def initialize(customer, guest_token)
      @customer = customer
      @guest_token = guest_token
    end

    def call
      return if @guest_token.blank?

      guest_cart = Cart.find_by(guest_token: @guest_token)
      return unless guest_cart

      @customer.cart&.destroy

      guest_cart.update!(
        customer: @customer,
        guest_token: nil
      )
    end
  end
end
