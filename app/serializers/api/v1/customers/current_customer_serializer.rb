# frozen_string_literal: true

# app/serializers/api/v1/customers/current_customer_serializer.rb
module Api
  module V1
    module Customers
      class CurrentCustomerSerializer
        def initialize(customer)
          @customer = customer
        end

        def as_json(*)
          {
            customer: {
              id: @customer.id,
              email: @customer.email,
              first_name: @customer.first_name,
              last_name: @customer.last_name
            }
          }
        end
      end
    end
  end
end
