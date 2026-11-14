# frozen_string_literal: true

class AddTwoFactorFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    # add_column :users, :otp_secret, :string
    # add_column :users, :encrypted_otp_secret, :string
    # add_column :users, :encrypted_otp_secret_iv, :string
    # add_column :users, :encrypted_otp_secret_salt, :string
    # add_column :users, :consumed_timestep, :integer
    # add_column :users, :otp_required_for_login, :boolean, default: false
    # add_column :users, :second_factor_attempts_count, :integer, default: 0
    # # このフラグはあくまで補助（DB保管）
    # add_column :users, :remember_otp_session, :boolean, default: false
  end
end
