# frozen_string_literal: true

module Api
  module V1
    class CheckoutController < ApplicationController
      def confirm
        order = current_order
        payment_method = params[:payment_method]

        case payment_method
        when 'card'
          handle_card(order)
        when 'cod'
          handle_cod(order)
        else
          raise BusinessError.new(
            code: 'invalid_payment_method',
            message: '支払い方法が不正です'
          )  end
      end

      private

      def handle_card(order)
        ReserveStocks::ReserveService.new(order).call

        pending_payment = order.payments.find_by(payment_method: 'card', status: 'pending')

        payment_intent = if pending_payment
                           Stripe::UpdatePaymentIntentService.call(
                             pending_payment.stripe_payment_intent_id,
                             order
                           )
                         else
                           Stripe::CreatePaymentIntentService.call(order)
                         end

        render json: { client_secret: payment_intent.client_secret,
                       complete_token: order.complete_token }, status: :ok
      end

      def handle_cod(order)
        ActiveRecord::Base.transaction do
          ::ReserveStocks::ReserveService.new(order).call

          order.order_items.each do |item|
            item.sku.update!(
              stock: item.sku.stock - item.quantity
            )
          end

          ReservedStock.where(order_item: order.order_items).destroy_all

          payment = order.payments.create!(
            payment_method: 'cod',
            status: 'unpaid'
          )

          ::Carts::CleanupService.new(order).call

          order.confirm!(payment:)
        end

        OrderConfirmedMailerJob.perform_later(order.id)

        cookies.delete(:guest_token)

        render json: {
          complete_token: order.complete_token
        }, status: :ok
      end
    end
  end
end
