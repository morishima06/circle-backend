# frozen_string_literal: true

class CreateDesigners < ActiveRecord::Migration[6.1]
  def change
    create_table :designers do |t|
      t.string :name
      t.string :slug, null: false
      t.string :description
      t.timestamps
    end
    add_index :designers, :slug, unique: true
  end
end
