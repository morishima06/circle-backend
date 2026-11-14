# frozen_string_literal: true

module CartConcern
  extend ActiveSupport::Concern

  def current_cart
    cart =
      if current_customer
        current_customer.cart
      elsif guest_token.present?
        Cart.find_by(
          guest_token:
        )
      end

    return nil unless cart

    if cart.expired?
      cookies.delete(:guest_token) if guest_token.present? && !current_customer
      return nil
    end

    cart
  end

  def extend_guest_token_expiry
    return unless cookies[:guest_token]

    cookies[:guest_token] = {
      value: cookies[:guest_token],
      expires: 30.days.from_now,
      httponly: true,
      secure: Rails.env.production?
    }
  end

  def create_cart!
    if current_customer
      current_customer.create_cart!
    else
      token = SecureRandom.uuid

      cart = Cart.create!(
        guest_token: token
      )

      cookies.encrypted[:guest_token] = {
        value: token,
        expires: 30.days.from_now,
        httponly: true
      }

      cart
    end
  end
end
