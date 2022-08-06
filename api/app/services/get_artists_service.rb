# frozen_string_literal: true

class GetArtistsService < ApplicationService
  def call
    HandleGetArtistsWorker.perform_async(params)
    handle_response
  rescue StandardError => error
    error_response(error)
  end
end
