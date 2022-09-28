# frozen_string_literal: true

module ::Moat
  class SearchAlbumsService < ApplicationService
    def call
      params[:query] = sanitize do
        ['LOWER(name) like ?', "%#{params[:query]}%"]
      end
      Moat::HandleSearchAlbumsWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end
  end
end
