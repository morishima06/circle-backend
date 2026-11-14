# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.references :size_type, null: true, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :ancestry
      t.timestamps
    end

    add_index :categories, :slug, unique: true
  end
end
