# frozen_string_literal: true

class RemoveAlbumService < ApplicationService
  def call
    HandleRemoveAlbumWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
