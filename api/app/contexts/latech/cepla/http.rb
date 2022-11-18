# frozen_string_literal: true

module ::Latech
  module Cepla
    module Http
      def self.prepended(mod)
        unless allowed_services.include?(mod.to_s.demodulize.underscore.to_sym)
          raise StandardError.new("Error on #{self} prepended to #{mod}")
        end
      end

      def self.allowed_services
        [:get_address]
      end

      def headers
        { accept: 'application/json' }
      end

      def uri
        ENV.fetch(LATECH_CEPLA_URI)
      end
    end
  end
end
