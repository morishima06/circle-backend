# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: true, foreign_key: true
      t.bigint :current_payment_id

      # 顧客情報
      t.string :customer_type, null: false, default: 'guest'
      t.integer :selected_address_id

      # 配送先
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :postal_code
      t.string :prefecture
      t.string :city
      t.string :address_line1
      t.string :address_line2
      t.string :phone_number

      # 注文情報
      t.string :number
      t.string :status, null: false, default: 'pending'
      t.datetime :ordered_at
      t.integer :shipping_fee
      t.integer :total

      # トークン
      t.string :guest_token
      t.string :complete_token

      t.string :notes
      t.datetime :expires_at
      t.timestamps
    end

    add_index :orders, :number,
              unique: true,
              where: 'number IS NOT NULL'

    # Customerごとにpending Orderは1つだけ
    add_index :orders, [:customer_id],
              unique: true,
              where: "customer_id IS NOT NULL AND status = 'pending'",
              name: 'index_orders_on_customer_pending'

    # Guest Tokenごとにpending Orderは1つだけ
    add_index :orders, [:guest_token],
              unique: true,
              where: "guest_token IS NOT NULL AND status = 'pending'",
              name: 'index_orders_on_guest_token_pending'

    add_index :orders, :guest_token
    add_index :orders, :complete_token
    add_index :orders, :expires_at
    add_index :orders, :status
    add_index :orders, :ordered_at

    add_check_constraint :orders,
                         '(customer_id IS NOT NULL AND guest_token IS NULL) OR ' \
                         '(customer_id IS NULL AND guest_token IS NOT NULL)',
                         name: 'customer_or_guest_token'
  end
end
