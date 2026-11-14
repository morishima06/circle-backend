# frozen_string_literal: true

module Api
  module V1
    module Customers
      class OrdersController < Api::V1::Customers::BaseController
        def index
          orders = current_customer.orders.where.not(status: 'pending')

          render json: Api::V1::Customers::Orders::Serializer.new(orders),
                 status: :ok
        end

        def show
          order = current_customer.orders.find_by!(number: params[:number])
          Rails.logger.debug order

          render json: Api::V1::Customers::Orders::DetailSerializer.new(order), status: :ok
        end
      end
    end
  end
end
