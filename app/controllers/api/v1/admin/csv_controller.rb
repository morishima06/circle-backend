# frozen_string_literal: true

require 'csv'

module Api
  module V1
    module Admin
      class CsvController < ApplicationController
        def export_orders
          orders = Order.where(id: params[:order_ids])

          csv_data = CSV.generate(headers: true) do |csv|
            csv << %w[
              注文番号
              注文日時
              氏名
              メールアドレス
              郵便番号
              住所
              電話番号
              合計金額
              ステータス
            ]

            orders.each do |order|
              csv << [
                order.number,
                format_datetime(order.ordered_at),
                "#{order.last_name} #{order.first_name}",
                order.email,
                order.postal_code,
                "#{order.prefecture}#{order.city}#{order.address_line1}",
                order.phone_number,
                order.total,
                order_status_label(order.status)
              ]
            end
          end

          send_data(
            csv_data,
            filename: "orders_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
            type: 'text/csv; charset=utf-8'
          )
        end

        def export_customers
          customers = Customer.where(id: params[:customer_ids])

          csv_data = CSV.generate(headers: true) do |csv|
            csv << %w[
              顧客ID
              名前
              メールアドレス
              電話番号
              ステータス
              登録日時
            ]

            customers.each do |customer|
              csv << [
                customer.id,
                "#{customer.last_name} #{customer.first_name}".strip,
                customer.email,
                customer.phone_number,
                customer_status_label(customer.status),
                format_datetime(customer.created_at)
              ]
            end
          end

          send_data(
            csv_data,
            filename: "customers_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv",
            type: 'text/csv; charset=utf-8'
          )
        end

        private

        def format_datetime(datetime)
          datetime&.strftime('%Y/%m/%d %H:%M')
        end

        def order_status_label(status)
          {
            'pending' => '注文待ち',
            'confirmed' => '注文確定',
            'shipped' => '発送済み',
            'on_hold' => '保留',
            'cancelled' => 'キャンセル'
          }.fetch(status, status)
        end

        def customer_status_label(status)
          {
            'active' => '有効',
            'suspended' => '一時停止',
            'banned' => '利用禁止',
            'withdrawn' => '退会済み'
          }.fetch(status, status)
        end
      end
    end
  end
end
