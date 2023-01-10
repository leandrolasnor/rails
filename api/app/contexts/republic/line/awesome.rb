# frozen_string_literal: true

module ::Republic
  module Line
    module Awesome
      # Cada litro de tinta é capaz de pintar 5 metros quadrados
      INK_LITER_YIELD = 5

      # Variações de tamanho das latas de tinta em litros
      KINDS = [0.5, 3.6, 18, 2.5].sort.reverse.freeze
    end
  end
end
