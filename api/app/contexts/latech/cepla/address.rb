# frozen_string_literal: true

module ::Latech
  module Cepla
    class Address
      attr_reader :address

      def initialize(address)
        @address = address
      end

      def capture
        yield(captured_address)
      end

      private

      def captured_address
        @captured_address ||=
          Latech::Cepla::Http::Services::GetAddress.call!(zip: address.zip)
      end
    end
  end
end
