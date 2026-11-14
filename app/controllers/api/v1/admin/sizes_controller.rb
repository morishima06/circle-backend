# frozen_string_literal: true

module Api
  module V1
    module Admin
      class SizesController < ApplicationController
        def index
          category = Category.find(params[:category_id])

          sizes = category.size_type&.sizes

          sizes = sizes ? sizes.select(:id, :label) : []

          render json: sizes
        end
      end
    end
  end
end
