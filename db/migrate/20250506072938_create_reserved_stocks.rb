# frozen_string_literal: true

class CreateReservedStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :reserved_stocks do |t|
      t.references :sku,        null: false, foreign_key: true
      t.references :order_item, null: false, foreign_key: true
      t.integer    :quantity,   null: false
      t.datetime   :expires_at, null: false

      t.timestamps
    end

    add_index :reserved_stocks, %i[sku_id order_item_id], unique: true
    add_index :reserved_stocks, :expires_at
  end
end
