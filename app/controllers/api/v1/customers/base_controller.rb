# frozen_string_literal: true

module Api
  module V1
    module Customers
      class BaseController < ApplicationController
        before_action :require_customer_login

        private

        def require_customer_login
          return if current_customer

          render json: {
            error: {
              code: 'unauthorized',
              message: 'ログインしてください'
            }
          }, status: :unauthorized
        end
      end
    end
  end
end
