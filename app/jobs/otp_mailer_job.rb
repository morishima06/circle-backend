# frozen_string_literal: true

class OtpMailerJob < ApplicationJob
  queue_as :default

  def perform(email, otp)
    CustomerMailer.send_otp_email(email, otp).deliver_later
  end
end
