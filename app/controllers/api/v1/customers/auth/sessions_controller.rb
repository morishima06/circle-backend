# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Auth
        class SessionsController < ApplicationController
          def create
            customer = authenticate_customer

            return render_login_failure unless customer

            return render_2fa_required(customer) if two_factor_required?(customer)

            complete_sign_in(customer)
            render_login_success
          end

          def destroy
            sign_out(current_customer)

            delete_signed_in_cookie
            cookies.delete(:guest_token)

            head :no_content
          end

          def current
            if current_customer
              render json: Api::V1::Customers::CurrentCustomerSerializer
                .new(current_customer), status: :ok
            else
              render json: { customer: nil }, status: :ok
            end
          end

          private

          def authenticate_customer
            customer = Customer.find_for_authentication(
              email: session_params[:email]
            )

            return customer if customer&.valid_password?(session_params[:password])

            log_login_failure
            nil
          end

          def render_login_failure
            render json: {
              error: {
                code: 'validation_failed',
                fields: {
                  password: ['メールアドレスまたはパスワードが正しくありません']
                }
              }
            }, status: :unprocessable_entity
          end

          def render_2fa_required(customer)
            send_otp(customer)

            render json: {
              requires_2fa: true
            }, status: :ok
          end

          def complete_sign_in(customer)
            sign_in(
              :customer,
              customer,
              remember_me: session_params[:remember_me] == true
            )

            Rails.logger.info(
              "[LOGIN SUCCESS] customer_id=#{customer.id} ip=#{request.remote_ip}"
            )

            set_signed_in_cookie

            guest_token = cookies.encrypted[:guest_token]
            ::Carts::MergeGuestCartService.new(customer, guest_token).call
          end

          def render_login_success
            render json: {
              requires_2fa: false
            }, status: :ok
          end

          def log_login_failure
            Rails.logger.warn(
              "[LOGIN FAILED] email=#{session_params[:email]} ip=#{request.remote_ip}"
            )
          end

          def send_otp(customer)
            otp = rand(100_000..999_999).to_s

            Rails.cache.write(
              "otp:customer:#{customer.id}",
              otp,
              expires_in: 10.minutes
            )

            session[:pre_2fa_customer_id] = customer.id

            CustomerMailer.send_otp(customer, otp).deliver_later
          end

          def two_factor_required?(customer)
            trusted_token = cookies.encrypted[:trusted_device_token]

            customer.two_factor_enabled? &&
              !customer.trusted_device_valid?(trusted_token)
          end

          def session_params
            params.require(:customer).permit(:email, :password, :remember_me)
          end
        end
      end
    end
  end
end
