# frozen_string_literal: true

REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))

begin
  Rails.logger.info("[Redis Check] #{REDIS.ping}")
rescue StandardError => e
  Rails.logger.error("[Redis Check] FAILED: #{e.class}: #{e.message}")
end