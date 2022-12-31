# frozen_string_literal: true

module ::Nexoos
  module Financial
    class Loan
      attr_reader :loan

      def initialize(loan)
        @loan = loan
      end

      def pmt
        i = loan.rate.to_f / 10000
        pv = loan.pv.to_f / 100
        n = loan.nper

        numerator = i * ((1 + i)**n)
        denominator = ((1 + i)**n) - 1
        (pv * (numerator / denominator)).round(2)
      end
    end
  end
end
