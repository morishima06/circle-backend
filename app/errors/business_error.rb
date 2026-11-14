# frozen_string_literal: true

# app/errors/business_error.rb
class BusinessError < StandardError
  attr_reader :code, :status

  def initialize(code:, message:, status: :unprocessable_entity)
    @code = code
    @status = status

    super(message)
  end
end
