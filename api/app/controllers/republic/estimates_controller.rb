# frozen_string_literal: true

module ::Republic
  class EstimatesController < ApiController
    def quantity_of_can_of_paint
      deliver(CalculateQuantityOfCanOfPaintService.call(quantity_of_can_of_paint_params))
    end

    private

    def estimate_params
      params.fetch(:estimate, {})
    end

    def quantity_of_can_of_paint_params
      estimate_params.permit(
        halls: [
          walls: [
            :height,
            :width,
            :windows_count,
            :doors_count
          ]
        ]
      )
    end
  end
end
