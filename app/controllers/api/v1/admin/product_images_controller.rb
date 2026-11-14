# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProductImagesController < ApplicationController
        def create
          blob = ActiveStorage::Blob.create_and_upload!(
            io: params[:image][:file],
            filename: params[:image][:file].original_filename,
            content_type: params[:image][:file].content_type
          )

          Rails.logger.debug 999_999_999
          Rails.logger.debug blob
          render json: { signed_id: blob.signed_id, url: url_for(blob) }
        end
      end
    end
  end
end
