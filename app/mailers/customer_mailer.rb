# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  layout 'mailer'

  def send_activation_email(email, activation_token)
    @email = email
    @token = activation_token

    mail(to: @email)
  end

  def account_activation(customer)
    @customer = customer
    @reset_link = "#{ENV.fetch('TEST_APP_URL', nil)}/" \
                  "register-verify/#{@customer.activation_token}/" \
                  "edit?email=#{ERB::Util.url_encode(@customer.email)}"
    mail(to: @customer.email)
  end

  def password_reset(customer, token)
    @customer = customer
    @reset_link = "#{ENV.fetch('TEST_APP_URL', nil)}/" \
                  "password-resets/#{ERB::Util.url_encode(token)}/" \
                  "edit?email=#{ERB::Util.url_encode(@customer.email)}"
    mail(to: customer.email)
  end

  def send_otp(customer, otp)
    @customer = customer
    @otp = otp
    mail(to: @customer.email)
  end
end
