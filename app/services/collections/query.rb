# frozen_string_literal: true

module Collections
  class Query
    Result = Struct.new(
      :products,
      :designers,
      :categories,
      :colors,
      keyword_init: true
    )

    def initialize(context:, category:, designer:, color:, sort:, keyword:, page:, per:)
      @context = context
      @category = category
      @designer = designer
      @color = color
      @sort = sort
      @keyword = keyword
      @page = page
      @per = per
    end

    def call
      Result.new(
        products:,
        designers:,
        categories:,
        colors:
      )
    end

    private

    # 商品検索の共通条件
    def base_scope
      scope = Product.all

      scope = scope.sale if @context == 'sale'
      scope = scope.new_arrivals if @context == 'new-arrivals'
      scope = scope.search(@keyword) if @keyword.present?

      scope
    end

    # カテゴリ候補用の検索条件
    def category_scope
      scope = base_scope

      scope = scope.by_designer(@designer) if @designer
      scope = scope.by_color(@color) if @color.present?

      scope
    end

    # デザイナー候補用の検索条件
    def designer_scope
      scope = base_scope

      scope = scope.by_category(@category) if @category
      scope = scope.by_color(@color) if @color.present?

      scope
    end

    # カラー候補用の検索条件
    def color_scope
      scope = base_scope

      scope = scope.by_category(@category) if @category
      scope = scope.by_designer(@designer) if @designer

      scope
    end

    # 商品一覧
    def products
      scope = base_scope

      scope = scope.by_category(@category) if @category
      scope = scope.by_designer(@designer) if @designer
      scope = scope.by_color(@color) if @color.present?

      scope
        .order(product_order)
        .page(@page)
        .per(@per)
    end

    # デザイナー候補一覧
    def designers
      Designer
        .joins(:products)
        .merge(designer_scope.reorder(nil))
        .select('designers.*, LOWER(designers.name) AS sort_name')
        .distinct
        .order('sort_name ASC')
    end

    # カラー候補一覧
    def colors
      Color
        .joins(:products)
        .merge(color_scope.reorder(nil))
        .distinct
    end

    # カテゴリ候補一覧（親子階層を維持）
    def categories
      filtered_categories =
        Category
        .joins(:products)
        .merge(category_scope.reorder(nil))
        .distinct

      category_ids =
        filtered_categories
        .flat_map(&:path_ids)
        .uniq

      Category
        .where(id: category_ids)
        .arrange
    end

    # 商品の並び順
    def product_order
      case @sort
      when 'price-asc'
        { price: :asc }
      when 'price-desc'
        { price: :desc }
      else
        { id: :desc }
      end
    end
  end
end
