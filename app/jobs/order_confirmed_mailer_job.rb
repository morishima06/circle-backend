# frozen_string_literal: true

class OrderConfirmedMailerJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)

    OrderMailer.confirmed(order).deliver_later
  end
end
