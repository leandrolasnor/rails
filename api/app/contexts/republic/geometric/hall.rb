# frozen_string_literal: true

module ::Republic
  module Geometric
    class Hall
      attr_reader :hall

      def initialize(hall)
        @hall = hall
      end

      def paintable_area
        hall.walls.sum { |wall| (wall.area - wall.doors_area - wall.windows_area) }
      end
    end
  end
end
