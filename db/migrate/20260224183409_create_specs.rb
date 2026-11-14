# frozen_string_literal: true

class CreateSpecs < ActiveRecord::Migration[6.1]
  def change
    create_table :specs do |t|
      t.references :product, null: false, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
