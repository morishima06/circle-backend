# frozen_string_literal: true

module Api
  module V1
    module Designers
      class Serializer
        def initialize(designers)
          @designers = designers
        end

        def as_json(*)
          @designers.map do |designer|
            {
              id: designer.id,
              name: designer.name,
              slug: designer.slug
            }
          end
        end
      end
    end
  end
end
