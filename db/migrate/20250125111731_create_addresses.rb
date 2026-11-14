# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :last_name
      t.string :first_name
      t.string :last_name_kana
      t.string :first_name_kana
      t.string :postal_code, null: false
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :address_line1, null: false
      t.string :address_line2
      t.string :phone_number, null: false
      t.boolean :is_default, default: false, null: false
      t.string :address_type, default: 'shipping' # デフォルトは配送先

      t.timestamps
    end
  end
end
