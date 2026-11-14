# frozen_string_literal: true

class CreateColors < ActiveRecord::Migration[6.1]
  def change
    create_table :colors do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :group_slug, null: false

      t.timestamps
    end

    add_index :colors, :slug, unique: true
    add_index :colors, :group_slug
  end
end
