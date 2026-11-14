# frozen_string_literal: true

module Api
  module V1
    class DesignersController < ApplicationController
      INITIALS = ['others'] + ('A'..'Z').to_a

      def index
        designers = Designer.order(:name)

        grouped = INITIALS.index_with { [] }
        Rails.logger.debug designers

        designers.each do |designer|
          key = initial_key(designer.name)

          grouped[key] << serialize(designer)
        end
        Rails.logger.debug grouped

        render json: grouped
      end

      def suggestions
        query = params[:q].to_s.downcase.gsub(/[^a-z0-9]/, '')

        return render json: [] if query.blank?

        designers = Designer.where(
          "LOWER(regexp_replace(name, '[^a-zA-Z0-9]', '', 'g')) LIKE ?",
          "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
        ).order(:name).limit(20)

        render json: designers.select(:id, :name, :slug)
      end

      private

      # A-Z ならその文字、それ以外は #
      def initial_key(name)
        first = name[0].upcase
        first.match?(/\A[A-Z]\z/) ? first : 'others'
      end

      # 一覧用の最小レスポンス
      def serialize(designer)
        {
          id: designer.id,
          name: designer.name,
          slug: designer.slug
        }
      end

      # ソートのクエリパラメータに基づいてプロダクトを並び替え
      def apply_sort_to_products(products)
        if params[:sort].present?
          case params[:sort]
          when 'price-asc'
            products.sorted_by_price(:asc)
          when 'price-desc'
            products.sorted_by_price(:desc)
          else
            products
          end
        else
          products # デフォルトの順序で返す
        end
      end
    end
  end
end
