# frozen_string_literal: true

module ::Moat
  class CreateAlbumService < ApplicationService
    def call
      Moat::HandleCreateAlbumWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error)
      error_response
    end
  end
end
