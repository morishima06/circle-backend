# frozen_string_literal: true

class HealthController < ApplicationController

  def show
    render json: {
      status: "ok"
    }, status: :ok
  end

  # DB・Redisの接続確認
  def ready
    checks = {
      database: database_check,
      # redis: redis_check
    }

    healthy = checks.values.all? { |status| status == "ok" }

    render json: {
      status: healthy ? "ok" : "error",
      checks: checks
    }, status: healthy ? :ok : :service_unavailable
  end

  private

  def database_check
    ActiveRecord::Base.connection.execute("SELECT 1")
    "ok"
  rescue StandardError
    "error"
  end

  # def redis_check
  #   Sidekiq.redis { |connection| connection.ping }
  #   "ok"
  # rescue StandardError
  #   "error"
  # end

end
