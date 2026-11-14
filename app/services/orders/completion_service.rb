# frozen_string_literal: true

module Orders
  class CompletionService
    def self.call(order, payment)
      return if order.confirmed?

      ActiveRecord::Base.transaction do
        order.order_items.each do |item|
          item.sku.decrement!(:stock, item.quantity)
        end

        ReservedStock.where(order_item: order.order_items).destroy_all

        Carts::CleanupService.new(order).call

        order.confirm!(payment:)
      end

      OrderConfirmedMailerJob.perform_later(order.id)
    end
  end
end
