# frozen_string_literal: true

module Admins
  class ProductImageSyncService
    def initialize(product:, images:)
      @product = product
      @images = images || []
    end

    def call
      raise ActiveRecord::RecordInvalid, @product if @images.blank?

      existing_product_images = load_existing_product_images
      existing_product_images_by_id = existing_product_images.index_by(&:id)

      submitted_existing_ids = extract_existing_ids
      validate_existing_ids!(submitted_existing_ids, existing_product_images_by_id)

      submitted_blobs = load_submitted_blobs

      destroy_removed_images!(existing_product_images, submitted_existing_ids)
      reset_positions!

      sync_images!(
        existing_product_images_by_id,
        submitted_blobs
      )

      @product
    end

    private

    def load_existing_product_images
      @product.product_images
              .includes(image_attachment: :blob)
              .to_a
    end

    def extract_existing_ids
      @images
        .filter_map { |image| image[:id].presence }
        .map(&:to_i)
    end

    def validate_existing_ids!(submitted_ids, existing_images_by_id)
      submitted_ids.each do |image_id|
        next if existing_images_by_id.key?(image_id)

        raise ActiveRecord::RecordNotFound,
              "ProductImage #{image_id} is not part of Product #{@product.id}"
      end
    end

    def load_submitted_blobs
      @images.each_with_object({}) do |image, blobs|
        signed_id = image[:signed_id].presence
        next unless signed_id

        blobs[signed_id] = ActiveStorage::Blob.find_signed!(signed_id)
      end
    end

    def destroy_removed_images!(existing_images, submitted_ids)
      existing_images.each do |product_image|
        product_image.destroy! unless submitted_ids.include?(product_image.id)
      end
    end

    def reset_positions!
      @product.product_images.each do |product_image|
        product_image.update!(position: -product_image.id)
      end
    end

    def sync_images!(existing_images_by_id, submitted_blobs)
      @images.each_with_index do |image, index|
        position = index + 1

        if image[:id].present?
          update_existing_image!(
            image,
            position,
            existing_images_by_id
          )
        elsif image[:signed_id].present?
          create_new_image!(
            image,
            position,
            submitted_blobs
          )
        else
          raise ActiveRecord::RecordInvalid, @product
        end
      end
    end

    def update_existing_image!(image, position, existing_images_by_id)
      product_image =
        existing_images_by_id.fetch(image[:id].to_i)

      product_image.update!(position:)
    end

    def create_new_image!(image, position, submitted_blobs)
      signed_id = image[:signed_id]
      blob = submitted_blobs.fetch(signed_id)

      product_image =
        @product.product_images.build(position:)

      product_image.image.attach(blob)
      product_image.save!
    end
  end
end
