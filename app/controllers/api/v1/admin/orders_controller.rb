# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrdersController < ApplicationController
        def index
          orders = filtered_orders
                   .recent
                   .page(params[:page])
                   .per(params[:per_page])

          render json: {
            orders: Api::V1::Admin::Orders::Serializer.new(orders).as_json,
            pagination: Api::V1::Admin::PaginationSerializer.new(orders).as_json
          }
        end

        def show
          order = Order.includes(
            :order_items,
            :shipment,
            current_payment: []
          ).find(params[:id])

          render json: Api::V1::Admin::Orders::DetailSerializer.new(order)
        end

        def ship
          order = Order.find(params[:id])
          shipment = order.shipment

          ActiveRecord::Base.transaction do
            order.update!(
              status: :shipped
            )

            shipment.update!(
              status: :shipped,
              carrier_name: params[:carrier],
              tracking_number: params[:tracking_number],
              shipped_at: Time.current
            )
          end

          ShipmentMailer.shipped(order).deliver_later

          render status: :ok
        end

        def counts
          render json: {
            order_tasks_count:
          }
        end

        private

        def filtered_orders
          orders = Order.all

          orders = orders.search_keyword(params[:keyword]) if params[:keyword].present?
          orders = filter_by_status(orders)
          orders = orders.with_payment_status(params[:payment_status]) if params[:payment_status].present?

          orders
        end

        def filter_by_status(orders)
          return orders if params[:order_status].blank?

          statuses = params[:order_status]
                     .split(',')
                     .select { |status| status.in?(Order.statuses.keys) }

          return orders if statuses.empty?

          orders.with_statuses(statuses)
        end

        def awaiting_shipment_count
          Order.awaiting_shipment.count
        end

        def payment_pending_count
          Payment.where(
            payment_method: 'bank_transfer',
            status: 'pending'
          ).count
        end

        def on_hold_count
          Order.on_hold.count
        end

        def order_tasks_count
          awaiting_shipment_count +
            payment_pending_count +
            on_hold_count
        end
      end
    end
  end
end
