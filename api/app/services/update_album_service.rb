# frozen_string_literal: true

class UpdateAlbumService < ApplicationService
  def call
    HandleUpdateAlbumWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
