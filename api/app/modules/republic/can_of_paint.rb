# frozen_string_literal: true

module ::Republic
  module CanOfPaint
    prepend Line::Awesome
    class << self
      def for_paint(area)
        area = 0 if area.negative?
        liters = area.to_f / Republic::CanOfPaint::INK_LITER_YIELD
        necessary_material = Array.new(Republic::CanOfPaint::KINDS.count)
        calculate_material(necessary_material, liters)
      end

      def calculate_material(necessary_material, liters, index = 0)
        cop = Republic::CanOfPaint::KINDS[index]
        quantity, liters = liters.divmod(cop)
        necessary_material[index] = { cop: cop, quantity: quantity }
        if necessary_material.last.nil?
          necessary_material = calculate_material(necessary_material, liters, index + 1)
        elsif liters.positive?
          necessary_material.last[:quantity] += 1
        end
        if index.positive? && necessary_material[index][:quantity] * necessary_material[index][:cop] == necessary_material[index - 1][:cop]
          necessary_material[index][:quantity] = 0
          necessary_material[index - 1][:quantity] += 1
        end
        necessary_material
      end
    end
  end
end
