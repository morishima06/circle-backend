# frozen_string_literal: true

class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :last_name_kana
      t.string :first_name_kana

      t.date :birth_date
      t.string :gender
      t.string :phone_number

      t.timestamps
    end
  end
end
