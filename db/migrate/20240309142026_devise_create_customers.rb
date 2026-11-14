# frozen_string_literal: true

class DeviseCreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      ## Devise
      t.string :email, null: false, default: ''
      t.string :encrypted_password, default: ''

      ## Profile
      t.string :last_name
      t.string :first_name
      t.string :last_name_kana
      t.string :first_name_kana
      t.date   :birth_date
      t.string :gender
      t.string :phone_number

      ## Account
      t.string :status, null: false, default: 'active'
      t.datetime :last_verified_at

      ## 2FA
      t.boolean :two_factor_enabled, default: true, null: false
      t.string   :trusted_device_token_digest
      t.datetime :trusted_device_token_expires_at

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.string :guest_token

      t.timestamps null: false
    end

    add_index :customers, :email, unique: true
    add_index :customers, :reset_password_token, unique: true
    add_index :customers, :guest_token, unique: true
  end
end
