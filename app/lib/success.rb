# frozen_string_literal: true

class Success
  attr_reader :value

  def initialize(value = nil)
    @value = value
  end

  def success?
    true
  end
end
