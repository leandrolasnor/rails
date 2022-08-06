# frozen_string_literal: true

class CreateAlbumService < ApplicationService
  def call
    HandleCreateAlbumWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
