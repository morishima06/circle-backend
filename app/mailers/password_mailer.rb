# frozen_string_literal: true

class PasswordMailer < ApplicationMailer
  def reset_email
    @customer = params[:customer]
    @token = params[:token]
    @reset_link = "#{ENV.fetch('TEST_APP_URL', nil)}/password-reset?token=#{@token}"

    mail(to: @customer.email)
  end
end
