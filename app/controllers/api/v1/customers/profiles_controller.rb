# frozen_string_literal: true

module Api
  module V1
    module Customers
      class ProfilesController < Api::V1::Customers::BaseController
        def show
          profile = current_customer.profile
          render json: { profile: }
        end

        def update
          profile = current_customer.profile

          profile.update!(profile_params)
          head :no_content
        end

        private

        # 許可するパラメータ
        def profile_params
          params.require(:profile).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :phone_number,
                                          :birth_date, :gender)
        end
      end
    end
  end
end
