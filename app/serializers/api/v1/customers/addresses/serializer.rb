# frozen_string_literal: true

module Api
  module V1
    module Customers
      module Addresses
        class Serializer
          def initialize(addresses)
            @addresses = addresses
          end

          def as_json(*)
            if @addresses.respond_to?(:to_ary)
              @addresses.map { |address| serialize(address) }
            else
              serialize(@addresses)
            end
          end

          private

          def serialize(address)
            {
              id: address.id,
              last_name: address.last_name,
              first_name: address.first_name,
              last_name_kana: address.last_name_kana,
              first_name_kana: address.first_name_kana,
              postal_code: address.postal_code,
              prefecture: address.prefecture,
              city: address.city,
              address_line1: address.address_line1,
              address_line2: address.address_line2,
              phone_number: address.phone_number,
              is_default: address.is_default
            }
          end
        end
      end
    end
  end
end
