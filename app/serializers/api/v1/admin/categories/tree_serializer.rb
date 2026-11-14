# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Categories
        class TreeSerializer
          def initialize(nodes)
            @nodes = nodes
          end

          def as_json(*)
            serialize_tree(@nodes)
          end

          private

          def serialize_tree(nodes)
            nodes.map do |category, children|
              {
                id: category.id,
                name: category.name,
                slug: category.slug,
                children: serialize_tree(children)
              }
            end
          end
        end
      end
    end
  end
end
