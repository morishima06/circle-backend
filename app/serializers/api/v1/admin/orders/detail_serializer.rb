# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Orders
        class DetailSerializer
          def initialize(order)
            @order = order
          end

          def as_json(*)
            {
              id: @order.id,
              number: @order.number,
              status: @order.status,
              ordered_at: @order.ordered_at,
              notes: @order.notes,

              shipping: {
                name: "#{@order.last_name} #{@order.first_name}",
                email: @order.email,
                postal_code: @order.postal_code,
                prefecture: @order.prefecture,
                city: @order.city,
                address_line1: @order.address_line1,
                address_line2: @order.address_line2,
                phone_number: @order.phone_number
              },

              payment: {
                payment_method: @order.current_payment&.payment_method,
                status: @order.current_payment&.status,
                total: @order.total,
                shipping_fee: @order.shipping_fee
              },

              shipment: @order.shipment && {
                status: @order.shipment.status,
                carrier_name: @order.shipment.carrier_name,
                tracking_number: @order.shipment.tracking_number,
                shipped_at: @order.shipment.shipped_at,
                delivered_at: @order.shipment.delivered_at
              },

              items: @order.order_items.map do |item|
                {
                  id: item.id,
                  name: item.name,
                  designer: item.designer,
                  color: item.color,
                  size: item.size,
                  price: item.price,
                  original_price: item.original_price,
                  quantity: item.quantity
                }
              end
            }
          end
        end
      end
    end
  end
end
