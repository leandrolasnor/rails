# frozen_string_literal: true

module ::Moat
  class GetArtistsService < ApplicationService
    def call
      Moat::HandleGetArtistsWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error)
      error_response
    end
  end
end
