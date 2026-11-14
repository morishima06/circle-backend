# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def confirmed(order)
    @order = order

    mail(
      to: order.email
    )
  end

  def shipped(order)
    @order = order

    mail(
      to: order.email
    )
  end
end
