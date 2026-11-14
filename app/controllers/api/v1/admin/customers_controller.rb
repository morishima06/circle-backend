# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CustomersController < ApplicationController
        def index
          customers = Customer.all
          customers = filter_by_status(customers)
          customers = filter_by_keyword(customers)
          customers = paginate(customers)

          render json: {
            customers: Api::V1::Admin::Customers::Serializer.new(customers),
            pagination: Api::V1::Admin::PaginationSerializer.new(customers)
          }
        end

        private

        def filter_by_status(customers)
          return customers if params[:status].blank?

          statuses = params[:status]
                     .to_s
                     .split(',')
                     .map(&:strip)
                     .compact_blank

          return customers if statuses.empty?

          customers.where(status: statuses)
        end

        def filter_by_keyword(customers)
          return customers if params[:keyword].blank?

          keyword = "%#{ActiveRecord::Base.sanitize_sql_like(params[:keyword])}%"

          customers.where(
            "last_name ILIKE :keyword
             OR first_name ILIKE :keyword
             OR email ILIKE :keyword
             OR phone_number ILIKE :keyword",
            keyword:
          )
        end

        def paginate(customers)
          customers
            .order(created_at: :desc)
            .page(params[:page])
            .per(params[:per_page])
        end
      end
    end
  end
end
