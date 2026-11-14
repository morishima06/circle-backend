module Api
  module V1
    class SearchController < ApplicationController
      def index
        products = Product
                   .includes(:designer, :product_images)
                   .search(params[:q].to_s)

        case params[:sort]
        when 'price_asc'
          products = products.order(price: :asc)
        when 'price_desc'
          products = products.order(price: :desc)
        end

        render json: Api::V1::Searches::Serializer.new(products).as_json
      end
    end
  end
end
