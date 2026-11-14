# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DesignersController < ApplicationController
        def index
          designers = Designer.all
          render json: designers
        end

        def search
          return render json: [] if params[:q].blank?

          designers = Designer
                      .search_by_name(params[:q])
                      .order(:name)
                      .limit(20)

          render json: designers.as_json(
            only: %i[id name]
          )
        end
      end
    end
  end
end
