# frozen_string_literal: true

# def get_customer
#   @customer = Customer.find_by(email: params[:email])
#   unless @customer
#     render json: { error: "User not found." }, status: :not_found
#   end
# end
# def valid_customer
#   unless @customer&.activated? && @customer.authenticated?(:reset_password, params[:token])
#     render json: { error: "Invalid or expired token." }, status: :unauthorized
#   end
# end
# def check_expiration
#   if @customer.password_reset_expired?
#     render json: { error: "Password reset has expired." }, status: :unprocessable_entity
#   end
# end
module Api
  module V1
    module Customers
      module Auth
        class PasswordResetsController < ApplicationController
          def edit
            customer = Customer.find_by(email: params[:email])
            # pp 6767776776767
            # pp 89989898989
            #    pp customer&.authenticated_password_reset_token?(params[:token])

            if customer&.authenticated_password_reset_token?(params[:token])
              Rails.logger.debug 90_909_090_990

              render json: { success: true }, status: :ok
            else
              render json: { message: '無効または期限切れのリンクです' }, status: :unauthorized
            end
          end

          # before_action :get_customer,         only: [:edit, :update]
          # before_action :valid_customer,       only: [:edit, :update]
          # before_action :check_expiration, only: [:edit, :update]
          # POST /passwords/reset_request
          def create
            customer = Customer.find_by(email: params[:email])

            if customer
              token = customer.generate_password_reset_token!
              CustomerMailer.password_reset(customer, token).deliver_later if token.present?
            end

            # メールが存在するか否かに関わらず同じレスポンスを返す
            render json: {
              success: true,
              message: 'リセットメールリンクを送りました。'
            }, status: :ok
          end

          # POST /passwords/reset
          def update
            customer = Customer.find_by(email: params[:email])

            if customer&.authenticated_password_reset_token?(params[:token])
              if customer.update(password: params[:password])
                render json: { success: true, message: 'パスワードを更新しました' }, status: :ok
              else
                render json: { success: false, errors: customer.errors.full_messages }, status: :unprocessable_entity
              end
            else
              render json: { suucess: false }, status: :unauthorized
            end
          end

          private

          def user_params
            params.permit(:password, :password_confirmation)
          end

          # def get_customer
          #   @customer = Customer.find_by(email: params[:email])
          #   unless @customer
          #     render json: { error: "User not found." }, status: :not_found
          #   end
          # end

          # def valid_customer
          #   unless @customer&.activated? && @customer.authenticated?(:reset_password, params[:token])
          #     render json: { error: "Invalid or expired token." }, status: :unauthorized
          #   end
          # end

          # def check_expiration
          #   if @customer.password_reset_expired?
          #     render json: { error: "Password reset has expired." }, status: :unprocessable_entity
          #   end
          # end
        end
      end
    end
  end
end
