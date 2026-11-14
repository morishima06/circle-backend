# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Auth
        class RegistrationsController < ApplicationController
          def create
            customer = Customer.new(registrations_params)

            ActiveRecord::Base.transaction do
              customer.save!

              sign_in(:customer, customer, remember_me: false)

              customer.update!(last_verified_at: Time.current)

              guest_token = cookies[:guest_token]

              Carts::MergeGuestCartService.new(customer, guest_token).call if guest_token.present?
            end

            set_signed_in_cookie
            cookies.delete(:guest_token) if guest_token.present?

            head :created
          end

          private

          def registrations_params
            params.require(:customer).permit(
              :first_name,
              :last_name,
              :first_name_kana,
              :last_name_kana,
              :email,
              :password,
              :password_confirmation
            )
          end
        end
      end
    end
  end
end
