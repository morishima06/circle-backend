# frozen_string_literal: true

class AddOtpFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    # add_column :users, :otp_digest, :string
    # add_column :users, :otp_expires_at, :datetime

    # add_column :users, :otp_skip_token_digest, :string
    # add_column :users, :otp_skip_expires_at, :datetime
  end
end
