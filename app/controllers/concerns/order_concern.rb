# frozen_string_literal: true

module OrderConcern
  extend ActiveSupport::Concern

  def current_order
    if current_customer
      current_customer.orders.find_by!(status: :pending)
    else
      Order.find_by!(guest_token: cookies.encrypted[:guest_token], status: :pending)
    end
  end
end
