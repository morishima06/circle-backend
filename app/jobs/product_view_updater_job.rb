# frozen_string_literal: true

class ProductViewUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Product.find_each do |product|
      redis_key = "product:#{product.id}:views"

      views = REDIS.getset(redis_key, 0).to_i

      if views.positive?
        # 閲覧数をデータベースに加算
        product.increment!(:view_count, views)
      else
        # 閲覧数が 0 なら Redis のキーを削除
        REDIS.del(redis_key)
      end
    end
  end
end
