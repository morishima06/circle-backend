# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.string :guest_token
      t.references :customer, foreign_key: true, null: true, index: false

      t.timestamps
    end

    add_index :carts, :guest_token, unique: true
    add_index :carts, :customer_id, unique: true

    # 👇 どちらか必須制約
    add_check_constraint :carts,
                         '(guest_token IS NOT NULL OR customer_id IS NOT NULL)',
                         name: 'carts_guest_or_customer_presence'
  end
end
