# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ColorsController < ApplicationController
        def index
          colors = Color.order(:name)

          render json: colors.as_json(
            only: %i[id name]
          )
        end
      end
    end
  end
end
