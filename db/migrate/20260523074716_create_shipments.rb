# frozen_string_literal: true

class CreateShipments < ActiveRecord::Migration[6.1]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true

      t.string :status, null: false, default: 'preparing'

      # 配送情報
      t.string :carrier_name
      t.string :tracking_number
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps
    end

    add_index :shipments, :status
    add_index :shipments, :tracking_number
  end
end
