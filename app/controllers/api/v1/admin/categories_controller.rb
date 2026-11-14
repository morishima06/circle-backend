# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CategoriesController < ApplicationController
        def tree
          render json: Api::V1::Admin::Categories::TreeSerializer.new(
            Category.arrange
          )
        end
      end
    end
  end
end
