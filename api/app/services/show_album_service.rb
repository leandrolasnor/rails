# frozen_string_literal: true

class ShowAlbumService < ApplicationService
  def call
    HandleShowAlbumWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
