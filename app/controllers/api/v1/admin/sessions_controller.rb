# frozen_string_literal: true

module Api
  module V1
    module Admin
      class SessionsController < ApplicationController
        #   skip_before_action :verify_authenticity_token

        def current
          if current_admin
            render json: current_admin, status: :ok
          else
            render json: { error: 'Not logged in' }, status: :unauthorized
          end
        end

        # POST /admin/api/v1/login
        def create
          admin = Admin.find_for_database_authentication(email: params[:admin][:email])

          if admin&.valid_password?(params[:admin][:password])
            sign_in(:admin, admin)
            head :ok
          else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
          end
        end

        # DELETE /admin/api/v1/logout
        def destroy
          sign_out(:admin)
          head :no_content
        end
      end
    end
  end
end
