# frozen_string_literal: true

module Api
  module V1
    module Categories
      class Serializer
        def initialize(nodes)
          @nodes = nodes
        end

        def as_json(*)
          @nodes.flat_map do |category, children|
            if category.parent_id.nil?
              # Mens / Womens などのルートは除外
              self.class.new(children).as_json
            else
              {
                id: category.id,
                name: category.name,
                slug: category.slug,
                children: self.class.new(children).as_json
              }
            end
          end
        end
      end
    end
  end
end
