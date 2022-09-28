# frozen_string_literal: true

module ::Moat
  class Moat::RemoveAlbumService < ApplicationService
    def call
      Moat::HandleRemoveAlbumWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end
  end
end
