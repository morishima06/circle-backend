# frozen_string_literal: true

class CreateOauthIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_identities do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end
    add_index :oauth_identities,
              %i[customer_id provider],
              unique: true
    add_index :oauth_identities, %i[provider uid], unique: true
  end
end
