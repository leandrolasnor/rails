# frozen_string_literal: true

module ::Republic
  module CalculatePaintableArea
    class << self
      def from(params)
        paintable = Paintable.new(params)
        raise Republic::ConfigInvalid.new(paintable.errors.full_messages.flatten) if paintable.invalid?

        paintable.area
      end
    end
  end
end
