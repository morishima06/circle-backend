# frozen_string_literal: true

class ApplicationController < ActionController::API
  # include AuthConcern
  include ActionController::Cookies
  include ErrorHandlers
  include GuestTokenHandler

  include Devise::Controllers::Helpers

  include SignedInCookieConcern

  include ActionController::RequestForgeryProtection
  # protect_from_forgery with: :null_session
  # protect_from_forgery with: :exception

  include CartConcern
  include OrderConcern

  protect_from_forgery with: :exception
  before_action :set_csrf_token

  private

  def set_csrf_token
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      httponly: false,
      same_site: :lax,
      secure: Rails.env.production?
    }
  end
end
