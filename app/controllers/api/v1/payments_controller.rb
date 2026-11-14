# frozen_string_literal: true

module Api
  module V1
    class PaymentsController < ApplicationController
      def sync
        Rails.logger.debug 9_999_999_999
        Rails.logger.debug params[:token]

        order = Order.find_by!(complete_token: params[:complete_token])
        Rails.logger.debug order

        payment = order.current_payment
        Rails.logger.debug payment

        Payments::SyncService.call(order, payment)

        payment.reload

        Orders::CompletionService.call(order) if payment.status == 'succeeded'

        head :ok
      end
    end
  end
end
