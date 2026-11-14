# frozen_string_literal: true

module GuestTokenConcern
  extend ActiveSupport::Concern

  included do
    before_action :refresh_guest_token
  end

  private

  def refresh_guest_token
    return if cookies[:guest_token].blank?

    cookies[:guest_token] = {
      value: cookies[:guest_token],
      expires: 1.day.from_now,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax
    }
  end
end
