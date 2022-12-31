# frozen_string_literal: true

module ::Nexoos
  class SearchLoansService < ApplicationService
    def call
      Nexoos::HandleSearchLoansWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end
  end
end
