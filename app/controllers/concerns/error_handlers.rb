# frozen_string_literal: true

# app/controllers/concerns/error_handlers.rb
module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    # rescue_from ActionController::ParameterMissing, with: :bad_request
    # rescue_from ForbiddenError, with: :forbidden

    rescue_from StandardError, with: :internal_error
    rescue_from BusinessError, with: :business_error
    rescue_from ActiveRecord::RecordInvalid, with: :validation_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  def validation_error(error)
    render json: {
      error: {
        code: 'validation_failed',
        fields: error.record.errors.to_hash(full_messages: true)
      }
    }, status: :unprocessable_entity
  end

  def business_error(error)
    render json: {
      error: {
        code: error.code,
        message: error.message
      }
    }, status: error.status
  end

  def not_found(_error)
    render json: {
      error: {
        code: 'not_found',
        message: 'リソースが見つかりません'
      }
    }, status: :not_found
  end

  def bad_request(_error)
    render json: {
      error: {
        code: 'bad_request',
        message: 'リクエストが不正です'
      }
    }, status: :bad_request
  end

  def forbidden(_error)
    render json: {
      error: {
        code: 'forbidden',
        message: 'アクセスが許可されていません'
      }
    }, status: :forbidden
  end

  def internal_error(error)
    Rails.logger.error("#{error.class} #{error.message}")
    Rails.logger.error(error.backtrace.join("\n"))

    message =
      if Rails.env.test? || Rails.env.development?
        "#{error.class}: #{error.message}"
      else
        'エラーが発生しました。しばらくしてからお試しください'
      end

    render json: {
      error: {
        code: 'internal_server_error',
        message:
      }
    }, status: :internal_server_error
  end
end
