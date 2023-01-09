# frozen_string_literal: true

module ::Nexoos
  class CreateLoanService < ApplicationService
    def call
      Nexoos::HandleCreateLoanWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error)
      error_response
    end
  end
end
