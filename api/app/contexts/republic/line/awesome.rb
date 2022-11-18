# frozen_string_literal: true

module ::Republic
  module Line
    module Awesome
      INK_LITER_YIELD = 5 # Cada litro de tinta é capaz de pintar 5 metros quadrados
      KINDS = [0.5, 3.6, 18, 2.5].sort.reverse.freeze # Variações de tamanho das latas de tinta em litros
    end
  end
end
