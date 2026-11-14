# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Customers
        class Serializer
          def initialize(customers)
            @customers = customers
          end

          def as_json(*)
            @customers.map do |customer|
              {
                id: customer.id,
                name: "#{customer.last_name} #{customer.first_name}",
                email: customer.email,
                status: customer.status,
                phone_number: customer.phone_number,
                created_at: customer.created_at
              }
            end
          end
        end
      end
    end
  end
end
