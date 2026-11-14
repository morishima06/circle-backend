# frozen_string_literal: true

class OauthIdentity < ApplicationRecord
  belongs_to :customer

  validates :provider, presence: true
  validates :uid, presence: true
end
