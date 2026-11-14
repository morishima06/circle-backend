# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Auth
        class TwoFactorsController < ApplicationController
          def edit
            customer_id = session[:pre_2fa_customer_id]

            return render_session_expired if customer_id.blank?

            return render_otp_expired unless otp_exists?(customer_id)

            head :ok
          end

          def verify_otp
            customer = find_pre_2fa_customer

            return render_session_expired unless customer
            return render_otp_expired unless otp_exists?(customer.id)

            return render_invalid_otp unless valid_otp?(customer)

            complete_two_factor_sign_in(customer)

            head :no_content
          end

          private

          def find_pre_2fa_customer
            customer_id = session[:pre_2fa_customer_id]

            return if customer_id.blank?

            Customer.find(customer_id)
          end

          def otp_exists?(customer_id)
            Rails.cache.read("otp:customer:#{customer_id}").present?
          end

          def valid_otp?(customer)
            cached_otp = Rails.cache.read("otp:customer:#{customer.id}")

            cached_otp == params[:otp]
          end

          def complete_two_factor_sign_in(customer)
            Rails.cache.delete("otp:customer:#{customer.id}")

            token = SecureRandom.urlsafe_base64(32)

            customer.update!(
              trusted_device_token_digest: BCrypt::Password.create(token),
              trusted_device_token_expires_at: 30.days.from_now
            )

            trusted_device_cookie(token)

            sign_in(:customer, customer)
            set_signed_in_cookie

            session.delete(:pre_2fa_customer_id)
          end

          def trusted_device_cookie(token)
            cookies.encrypted[:trusted_device_token] = {
              value: token,
              expires: 30.days,
              httponly: true,
              secure: Rails.env.production?,
              same_site: :lax
            }
          end

          def render_session_expired
            render json: {
              error: {
                code: 'two_factor_session_expired',
                message: '認証セッションの有効期限が切れています'
              }
            }, status: :unauthorized
          end

          def render_otp_expired
            session.delete(:pre_2fa_customer_id)

            render json: {
              error: {
                code: 'otp_expired',
                message: '認証コードの有効期限が切れています'
              }
            }, status: :unauthorized
          end

          def render_invalid_otp
            render json: {
              error: {
                code: 'invalid_otp',
                message: '６桁の数値が一致しません'
              }
            }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
