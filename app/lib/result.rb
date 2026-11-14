# frozen_string_literal: true

module Result
  class Success
    attr_reader :value

    def initialize(value = nil)
      @value = value
    end

    def success?
      true
    end
  end

  class Failure
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def success?
      false
    end
  end
end
