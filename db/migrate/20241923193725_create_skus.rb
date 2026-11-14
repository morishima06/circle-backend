# frozen_string_literal: true

class CreateSkus < ActiveRecord::Migration[6.1]
  def change
    create_table :skus do |t|
      t.references :product, null: false, foreign_key: true
      t.references :size, null: false, foreign_key: true

      t.integer :stock, default: 0, null: false

      t.string :sku_code

      t.timestamps
    end

    add_index :skus, %i[product_id size_id], unique: true
    add_index :skus, :sku_code, unique: true
    add_check_constraint :skus, 'stock >= 0', name: 'stock_non_negative'
  end
end
