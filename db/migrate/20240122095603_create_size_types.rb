# frozen_string_literal: true

class CreateSizeTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :size_types do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
