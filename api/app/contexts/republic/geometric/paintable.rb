# frozen_string_literal: true

module ::Republic
  module Geometric
    class Paintable
      attr_reader :paintable

      def initialize(paintable)
        @paintable = paintable
      end

      def area
        paintable.halls.sum(&:paintable_area)
      end
    end
  end
end
