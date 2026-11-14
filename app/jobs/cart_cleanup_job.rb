# frozen_string_literal: true

class CartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Cart.where(updated_at: ...30.days.ago).destroy_all
  end
end
