# frozen_string_literal: true

module Api
  module V1
    class CollectionsController < ApplicationController
      def index
        # 1. URL解析・見出し作成
        resolved = Collections::ContextResolver.new(params).call

        if resolved.designer_not_found
          render json: { error: 'Designer Not Found' },
                 status: :not_found
          return
        end

        # 2. 商品・フィルター情報の取得
        result = Collections::Query.new(
          context: resolved.context,
          category: resolved.category,
          designer: resolved.designer,
          color: params[:color],
          sort: params[:sort],
          keyword: resolved.keyword,
          page: params[:page] || 1,
          per: params[:per] || 8
        ).call

        # 3. JSONレスポンス
        render json: {
          heading: resolved.heading,
          search: {
            keyword: resolved.keyword
          },
          products: Api::V1::Products::Serializer.new(
            result.products,
            gender: params[:gender]
          ),
          filters: {
            designers: Api::V1::Designers::Serializer.new(
              result.designers
            ),
            categories: Api::V1::Categories::Serializer.new(
              result.categories
            ),
            colors: Api::V1::Colors::Serializer.new(
              result.colors
            )
          },
          pagination: Api::V1::PaginationSerializer.new(
            result.products
          )
        }
      end
    end
  end
end
