# frozen_string_literal: true

module Collections
  class FilterOptions
    Result = Struct.new(
      :colors,
      :designers,
      :categories,
      keyword_init: true
    )

    def initialize(category_scope:, designer_scope:, color_scope:)
      @category_scope = category_scope
      @designer_scope = designer_scope
      @color_scope = color_scope
    end

    def call
      Result.new(
        colors: fetch_colors,
        designers: fetch_designers,
        categories: fetch_categories
      )
    end

    private

    def fetch_colors
      Color
        .joins(:products)
        .merge(@color_scope.reorder(nil))
        .distinct
    end

    def fetch_designers
      Designer
        .joins(:products)
        .merge(@designer_scope.reorder(nil))
        .select('designers.*, LOWER(designers.name) AS sort_name')
        .distinct
        .order('sort_name ASC')
    end

    def fetch_categories
      filtered_categories = Category
                            .joins(:products)
                            .merge(@category_scope.reorder(nil))
                            .distinct

      category_ids = filtered_categories
                     .flat_map(&:path_ids)
                     .uniq

      Category
        .where(id: category_ids)
        .arrange
    end
  end
end
