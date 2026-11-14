# frozen_string_literal: true

class OrderCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Order.where(order_status: 'pending')
         .where(expires_at: ...Time.current)
         .destroy_all
  end
end
