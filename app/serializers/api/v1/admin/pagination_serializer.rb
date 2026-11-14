# frozen_string_literal: true

module Api
  module V1
    module Admin
      class PaginationSerializer
        def initialize(records)
          @records = records
        end

        def as_json(*)
          {
            current_page: @records.current_page,
            total_pages: @records.total_pages,
            total_count: @records.total_count,
            per_page: @records.limit_value
          }
        end
      end
    end
  end
end
