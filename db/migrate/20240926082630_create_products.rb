# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.references :designer, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true

      t.string :name
      t.string :gender
      t.string :style_code
      t.string :style_code_slug
      t.integer :price, null: false
      t.string :search_name
      t.integer :sale_price # SALE価格
      t.datetime :sale_start_at                          # SALE開始
      t.datetime :sale_end_at                            # SALE終了
      t.datetime :release_at                             # 発売日
      t.integer :view_count, default: 0, null: false
      t.string :status, default: 'active'
      t.text :description

      t.timestamps
    end
    add_index :products, :search_name
  end
end
