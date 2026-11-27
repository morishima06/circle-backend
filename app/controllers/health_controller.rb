# frozen_string_literal: true

class HealthController < ApplicationController

  def show
      Rails.logger.info('[Log Check] HealthController reached')

    render json: {
      status: "ok"
    }, status: :ok
  end

  # DB・Redisの接続確認
  def ready
    database_ok = ActiveRecord::Base.connection.active?

    redis_ok = Sidekiq.redis do |redis|
      redis.ping == 'PONG'
    end

    if database_ok && redis_ok
      render json: {
        status: 'ok',
        database: 'ok',
        redis: 'ok'
      }, status: :ok
    else
      render json: {
        status: 'error',
        database: database_ok ? 'ok' : 'error',
        redis: redis_ok ? 'ok' : 'error'
      }, status: :service_unavailable
    end
  rescue StandardError
    render json: {
      status: 'error',
      message: 'dependency check failed'
    }, status: :service_unavailable
  end
  

end
