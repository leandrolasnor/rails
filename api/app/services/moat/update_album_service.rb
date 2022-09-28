# frozen_string_literal: true

module ::Moat
  class Moat::UpdateAlbumService < ApplicationService
    def call
      Moat::HandleUpdateAlbumWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end
  end
end
