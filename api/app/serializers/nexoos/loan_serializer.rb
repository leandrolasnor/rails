# frozen_string_literal: true

module ::Nexoos
  class LoanSerializer < ActiveModel::Serializer
    attributes :rate, :nper, :pv, :pmt

    def pmt
      object.pmt
    end
  end
end
