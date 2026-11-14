# frozen_string_literal: true

module Api
  module V1
    module Customers
      class AccountController < Api::V1::Customers::BaseController
        def show
          customer = current_customer
          render json: Api::V1::Customers::AccountSerializer.new(customer)
        end

        def update
          current_customer.update!(account_params)
          head :ok
        end

        def account_params
          params.require(:customer).permit(
            :first_name, :last_name,
            :first_name_kana, :last_name_kana,
            :email, :gender, :birth_date, :phone_number
          )
        end
      end
    end
  end
end
