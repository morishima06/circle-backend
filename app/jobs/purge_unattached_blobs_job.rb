# frozen_string_literal: true

class PurgeUnattachedBlobsJob < ApplicationJob
  queue_as :default

  def perform
    ActiveStorage::Blob
      .unattached
      .where(active_storage_blobs: { created_at: ...1.day.ago })
      .find_each(&:purge)
  end
end
