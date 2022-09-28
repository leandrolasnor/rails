# frozen_string_literal: true

module ::Latech
  class SearchAddresesService < ApplicationService
    def call
      Latech::HandleSearchAddresesWorker.perform_async(params)
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end
  end
end
