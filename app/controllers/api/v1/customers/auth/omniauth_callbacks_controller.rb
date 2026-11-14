# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Auth
        class OmniauthCallbacksController < ApplicationController
          skip_before_action :verify_authenticity_token, only: :google_oauth2

          def google_oauth2
            auth_hash = request.env['omniauth.auth']

            unless auth_hash
              redirect_to 'http://localhost:3000/login?error=auth_failed'
              return
            end

            customer = Customer.find_or_create_from_auth_hash(auth_hash)

            unless customer
              redirect_to 'http://localhost:3000/login?error=create_failed'
              return
            end

            sign_in(:customer, customer)

            set_signed_in_cookie

            guest_token = cookies.encrypted[:guest_token]

            Rails.logger.debug 'GUEST TOKEN'
            Rails.logger.debug guest_token

            ::Carts::MergeGuestCartService.new(customer, guest_token).call

            cookies.delete(:guest_token)

            redirect_to 'http://localhost:3000/customer'
          end
        end
      end
    end
  end
end
