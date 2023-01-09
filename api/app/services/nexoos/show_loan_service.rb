# frozen_string_literal: true

module ::Nexoos
  class ShowLoanService < ApplicationService
    def call
      Nexoos::HandleShowLoanWorker.perform_async(params) if cached_loan.nil?
      handle_response
    rescue StandardError => error
      Rails.logger.error(error)
      error_response
    end

    private

    def cached_loan
      handle_response[:content] = Rails.cache.read("#{__method__}/#{params.fetch(:id)}")
    end
  end
end
