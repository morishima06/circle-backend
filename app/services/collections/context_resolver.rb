# frozen_string_literal: true

module Collections
  class ContextResolver
    Result = Struct.new(
      :context,
      :category,
      :designer,
      :heading,
      :keyword,
      :designer_not_found,
      keyword_init: true
    )

    VALID_CONTEXTS = %w[sale new-arrivals].freeze

    def initialize(params)
      @params = params
    end

    def call
      segments = @params[:path].to_s.split('/').compact_blank

      context = resolve_context(segments)
      category = resolve_category(segments)
      designer = resolve_designer(segments)

      Result.new(
        context:,
        category:,
        designer:,
        heading: build_heading(context, category, designer),
        keyword: normalize_keyword(@params[:q]),
        designer_not_found: designer_not_found?
      )
    end

    private

    def resolve_context(segments)
      return unless VALID_CONTEXTS.include?(segments.first)

      segments.shift
    end

    def resolve_category(segments)
      category = nil

      while segments.first.present?
        candidate =
          if category
            category.subtree.find_by(slug: segments.first)
          else
            Category.find_by(slug: segments.first)
          end

        break unless candidate

        category = candidate
        segments.shift
      end

      category
    end

    def resolve_designer(segments)
      return unless segments.first == 'designers'

      segments.shift
      designer_slug = segments.shift

      @designer_not_found = true if designer_slug.blank?

      designer = Designer.find_by(slug: designer_slug)
      @designer_not_found = true unless designer

      designer
    end

    def designer_not_found?
      !!@designer_not_found
    end

    def build_heading(context, category, designer)
      heading_parts = []

      heading_parts << case context
                       when 'sale' then 'Sale'
                       when 'new-arrivals' then 'New Arrivals'
                       end

      heading_parts << category&.name
      heading_parts << designer&.name

      heading = heading_parts.compact.join(' - ')
      heading.presence || @params[:gender]&.capitalize
    end

    def normalize_keyword(keyword)
      return if keyword.blank?

      keyword
        .unicode_normalize(:nfkc)
        .downcase
        .tr('　', ' ')
        .gsub(/[._-]/, '')
        .squeeze(' ')
        .strip
    end
  end
end
