# frozen_string_literal: true

module ::Latech
  module Cepla
    class Address
      attr_reader :address

      def initialize(address)
        @address = address
      end

      def capture
        @captured_address ||= Latech::Cepla::Http::Services::GetAddress.call!(zip: address.zip) # HTTParty::Error
        yield(@captured_address)
      end
    end
  end
end
