# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :sku_id
      t.string  :name, null: false
      t.string  :color
      t.string  :size
      t.string  :designer
      t.integer :price, null: false
      t.integer :original_price, null: false

      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
