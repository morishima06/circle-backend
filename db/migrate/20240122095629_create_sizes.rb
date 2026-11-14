# frozen_string_literal: true

class CreateSizes < ActiveRecord::Migration[6.1]
  def change
    create_table :sizes do |t|
      t.references :size_type, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
