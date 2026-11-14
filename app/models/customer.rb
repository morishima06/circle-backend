# frozen_string_literal: true

class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product
  has_many :addresses, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :oauth_identities, dependent: :destroy

  enum status: {
    active: 'active',
    suspended: 'suspended',
    banned: 'banned',
    withdrawn: 'withdrawn'
  }

  def trusted_device_valid?(token)
    return false if token.blank?
    return false if trusted_device_token_digest.blank?
    return false if trusted_device_token_expires_at.blank?
    return false if trusted_device_token_expires_at < Time.current

    BCrypt::Password
      .new(trusted_device_token_digest)
      .is_password?(token)
  end

  # customer.rb
  def self.find_or_create_from_auth_hash(auth_hash)
    provider = auth_hash['provider']
    uid = auth_hash['uid']
    email = auth_hash.dig('info', 'email')

    # 既存のOAuthIdentityを探す
    oauth_identity = OauthIdentity.find_by(
      provider:,
      uid:
    )

    return oauth_identity.customer if oauth_identity

    # 同じemailのCustomerを探す
    existing_customer = Customer.find_by(email:)

    if existing_customer
      existing_customer.oauth_identities.find_or_create_by!(
        provider:,
        uid:
      )

      return existing_customer
    end

    # 新規Customer作成
    Customer.create!(
      email:,
      oauth_identities: [
        OauthIdentity.new(
          provider:,
          uid:
        )
      ]
    )
  end

  def password_required?
    return false if oauth_identities.present?

    super
  end
end
