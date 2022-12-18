# frozen_string_literal: true

module ::Latech
  class CaptureAddressService < ApplicationService
    def call
      if cached_address
        Latech::HandleMakeSureAssignmentWorker.perform_async(params.merge!(address_id: cached_address[:id]).stringify_keys!)
      else
        Latech::HandleCaptureAddressWorker.perform_async(params.stringify_keys!)
      end
      handle_response
    rescue StandardError => error
      Rails.logger.error(error.message)
      error_response
    end

    private

    def cached_address
      handle_response[:content][:payload] = Rails.cache.fetch("#{__method__}/#{params.fetch(:zip)}", expire_in: 12.hours, skip_nil: true) do
        ApplicationRecord.reader do
          Latech::Search::Address.find_by(zip: params.fetch(:zip))
        end
      end
    end
  end
end
