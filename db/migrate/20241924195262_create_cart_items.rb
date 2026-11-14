# frozen_string_literal: true

class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :sku, null: false, foreign_key: true
      t.integer :price
      t.integer :quantity, default: 0

      t.timestamps
    end
    add_index :cart_items, %i[cart_id sku_id], unique: true
  end
end
