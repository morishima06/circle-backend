# frozen_string_literal: true

module GuestTokenHandler
  extend ActiveSupport::Concern

  def guest_token
    cookies.encrypted[:guest_token]
  end
end
