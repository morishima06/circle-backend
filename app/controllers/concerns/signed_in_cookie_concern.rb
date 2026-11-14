# frozen_string_literal: true

# app/controllers/concerns/signed_in_cookie.rb
module SignedInCookieConcern
  extend ActiveSupport::Concern

  def set_signed_in_cookie
    cookies['is_signed_in'] = {
      value: 'true',
      httponly: false,
      same_site: :lax
    }
  end

  def delete_signed_in_cookie
    cookies.delete(:is_signed_in)
  end
end
