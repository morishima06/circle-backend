# frozen_string_literal: true

module Api
  module V1
    class OrdersController < ApplicationController
      def create
        order = find_or_initialize_order

        begin
          order.save! if order.new_record?
        rescue ActiveRecord::RecordNotUnique
          # 同時リクエストで別の処理が先にOrderを作った場合
          order = find_or_initialize_order
        end

        order.with_lock do
          refresh_order(order)
        end

        render json: Api::V1::Orders::DetailSerializer.new(order), status: :ok
      end

      def update
        order = current_order

        raise BusinessError.new('not_found', '商品が存在してません') unless order

        if order_params[:selected_address_id].present?
          address = current_customer.addresses.find(
            order_params[:selected_address_id]
          )

          order.update!(
            selected_address_id: address.id,
            last_name: address.last_name,
            first_name: address.first_name,
            postal_code: address.postal_code,
            prefecture: address.prefecture,
            city: address.city,
            address_line1: address.address_line1,
            address_line2: address.address_line2,
            phone_number: address.phone_number
          )
        else
          order.update!(
            order_params.merge(selected_address_id: nil)
          )
        end

        render json: Api::V1::Orders::DetailSerializer.new(order), status: :ok
      end

      def complete
        token = params[:token]
        order = Order.includes(:payments).find_by!(complete_token: token)

        if order.ordered_at.present? &&
           order.ordered_at < 1.day.ago

          raise BusinessError.new(
            code: 'token_expired',
            message: '有効期限が切れています'
          )
        end

        render json: Api::V1::Orders::CompleteSerializer.new(order), status: :ok
      end

      def find_or_initialize_order
        if current_customer
          # ログイン済みはcustomer_idで既存を探す
          Order.find_or_initialize_by(
            customer: current_customer,
            status: 'pending'
          ).tap do |o|
            o.email = current_customer.email
          end
        else
          # ゲストはguest_tokenで既存を探す
          Order.find_or_initialize_by(
            guest_token: current_cart.guest_token,
            status: 'pending'
          ).tap do |o|
            o.guest_token = current_cart.guest_token
          end
        end
      end

      def refresh_order(order)
        if order.expired? || cart_changed?(order)
          sync_cart_items(order)

          payment = order.current_payment
          payment.cancel! if payment&.cancelable?
        end

        order.update!(expires_at: 30.minutes.from_now)
      end

      # CARTとORDERの同期処理
      def sync_cart_items(order)
        order.order_items.destroy_all
        current_cart.cart_items.each do |item|
          order.order_items.build(
            sku_id: item.sku_id,
            quantity: item.quantity,
            name: item.sku.product.name,
            color: item.sku.product.color.name,
            designer: item.sku.product.designer.name,
            size: item.sku.size.label,
            price: item.sku.product.current_price,
            original_price: item.sku.product.price
          )
        end
      end

      def cart_changed?(order)
        cart_items = current_cart.cart_items.map do |item|
          [item.sku_id, item.quantity]
        end

        order_items = order.order_items.map do |item|
          [item.sku_id, item.quantity]
        end

        cart_items.sort != order_items.sort
      end

      def order_params
        params.require(:order).permit(
          :email,
          :address_id,
          :postal_code,
          :last_name,
          :first_name,
          :prefecture,
          :city,
          :address_line1,
          :address_line2,
          :phone_number,
          :selected_address_id
        )
      end
    end
  end
end
