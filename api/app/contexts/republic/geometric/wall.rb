# frozen_string_literal: true

module ::Republic
  module Geometric
    class Wall
      attr_reader :wall

      def initialize(wall)
        @wall = wall
      end

      def area
        wall.height.to_f * wall.width.to_f
      end

      def doors_area
        ENV.fetch('REPUBLIC_DOOR_HEIGHT').to_f * ENV.fetch('REPUBLIC_DOOR_WIDTH').to_f * wall.doors_count.to_i
      end

      def windows_area
        ENV.fetch('REPUBLIC_WINDOW_HEIGHT').to_f * ENV.fetch('REPUBLIC_WINDOW_WIDTH').to_f * wall.windows_count.to_i
      end

      def anpaintable_area_ratio
        (doors_area + windows_area) / area
      end
    end
  end
end
