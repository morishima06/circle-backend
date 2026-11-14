# frozen_string_literal: true

module Api
  module V1
    module Customers
      class AddressesController < Api::V1::Customers::BaseController
        before_action :set_address, only: %i[show update destroy]

        def index
          addresses = current_customer.addresses

          render json: Api::V1::Customers::Addresses::Serializer
            .new(addresses)
            .as_json
        end

        def show
          render json:
            Api::V1::Customers::Addresses::Serializer.new(@address).as_json
        end

        def create
          address = current_customer.addresses.build(address_params)

          if current_customer.addresses.empty?
            address.is_default = true
          elsif address.is_default?
            # 他の住所を一括でdefault解除するためupdate_allを使用
            current_customer.addresses.update_all(is_default: false)
          end

          address.save!

          render json: {
            address: Api::V1::Customers::Addresses::Serializer.new(address).as_json
          }, status: :created
        end

        def update
          Address.transaction do
            if address_params[:is_default] == true
              # 他の住所を一括でdefault解除するためupdate_allを使用
              current_customer.addresses
                              .where.not(id: @address.id)
                              .update_all(is_default: false)
            end

            @address.update!(address_params)
          end

          head :no_content
        end

        def destroy
          @address.destroy!

          head :no_content
        end

        private

        def set_address
          @address = current_customer.addresses.find(params[:id])
        end

        def address_params
          params.require(:address).permit(
            :last_name,
            :first_name,
            :last_name_kana,
            :first_name_kana,
            :postal_code,
            :prefecture,
            :city,
            :address_line1,
            :address_line2,
            :phone_number,
            :is_default
          )
        end
      end
    end
  end
end
