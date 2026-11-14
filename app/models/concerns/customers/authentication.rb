# frozen_string_literal: true

module Customers
  module Authentication
    extend ActiveSupport::Concern

    def current_customer
      @current_customer ||= session_customer || remember_customer
    end

    def login!(customer)
      Rails.logger.debug customer.id
      session[:customer_id] = customer.id
    end

    private

    def session_customer
      return unless session[:customer_id]
      return unless session[:two_factor_authenticated] == true

      Customer.find_by(id: session[:customer_id])
    end

    def remember_customer
      remember_token = cookies.permanent.signed[:remember_token]
      return unless remember_token

      customer = Customer.find_by(id: cookies.signed[:c_id])
      return unless customer

      return unless BCrypt::Password.new(
        customer.remember_digest
      ).is_password?(remember_token)

      session[:customer_id] = customer.id
      session[:two_factor_authenticated] = true
      customer
    end
  end
end
