# frozen_string_literal: true

module Api
  module V1
    module Customers
      class AccountSerializer
        def initialize(customer)
          @customer = customer
        end

        def as_json(*)
          {
            id: @customer.id,
            email: @customer.email,
            name: "#{@customer.last_name} #{@customer.first_name}",
            last_name: @customer.last_name,
            first_name: @customer.first_name,
            last_name_kana: @customer.last_name_kana,
            first_name_kana: @customer.first_name_kana,
            gender: @customer.gender,
            birth_date: @customer.birth_date,
            phone_number: @customer.phone_number,
            defaultAddress: default_address_json,
            addresses: addresses_json
          }
        end

        private

        def default_address_json
          address = default_address
          return nil unless address

          serialize_address(address)
        end

        def default_address
          @default_address ||= @customer.addresses.find_by(is_default: true)
        end

        def addresses_json
          @customer.addresses.map do |address|
            serialize_address(address)
          end
        end

        def serialize_address(address)
          {
            id: address&.id,
            lastName: address&.last_name,
            firstName: address&.first_name,
            last_name_kana: address&.last_name_kana,
            first_name_kana: address&.first_name_kana,
            postalCode: address&.postal_code,
            prefecture: address&.prefecture,
            city: address&.city,
            addressLine1: address&.address_line1,
            addressLine2: address&.address_line2,
            isDefault: address&.is_default
          }
        end
      end
    end
  end
end
