# frozen_string_literal: true

module ::Republic
  class CalculateQuantityOfCanOfPaintService < ApplicationService
    def call
      handle_response[:content][:payload] = cached_can_of_paint
      handle_response
    rescue KeyError, Republic::ConfigInvalid => error
      error_response[:content][:message] = error.message
      error_response[:status] = :bad_request
      error_response
    rescue StandardError => error
      Rails.logger.error(error)
      error_response
    end

    private

    def cached_can_of_paint
      Rails.cache.fetch(
        "#{__method__}/#{area}",
        expire_in: 1.hour,
        skip_nil: true
      ) do
        Republic::CanOfPaint.for_paint(area)
      end
    end

    def area
      @area ||= Republic::CalculatePaintableArea.from(params)
    end
  end
end
