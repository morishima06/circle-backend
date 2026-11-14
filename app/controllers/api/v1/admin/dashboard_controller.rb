# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DashboardController < ApplicationController
        def show
          render json: Admins::DashboardSummaryService.new.call
        end

        def chart
          render json: Admins::DashboardChartService.new(period:).call
        end

        private

        def period
          params[:period].presence_in(%w[weekly monthly yearly]) || 'weekly'
        end
      end
    end
  end
end
