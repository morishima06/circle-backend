# frozen_string_literal: true

module Api
  module V1
    module Colors
      class Serializer
        def initialize(colors)
          @colors = colors
        end

        def as_json(*)
          @colors.map do |color|
            {
              id: color.id,
              name: color.name,
              slug: color.slug
            }
          end
        end
      end
    end
  end
end
