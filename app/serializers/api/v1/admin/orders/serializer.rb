# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Orders
        class Serializer
          def initialize(orders)
            @orders = orders
          end

          def as_json(*)
            @orders.map do |order|
              {
                id: order.id,
                number: order.number,
                total: order.total,
                ordered_at: order.ordered_at,
                name: "#{order.last_name} #{order.first_name}",
                status: order.status,
                payment_status: order.current_payment&.status,
                payment_method: order.current_payment&.payment_method,
                shipment_status: order.shipment&.status
              }
            end
          end
        end
      end
    end
  end
end
