# frozen_string_literal: true

module ::Latech
  module Cepla
    module Http
      class Services::GetAddress
        prepend(Latech::Cepla::Http)
        attr_reader :url
        attr_reader :zip
        attr_reader :response

        def initialize(zip)
          @zip = zip
          @url = "#{uri}/#{zip}"
        end

        def self.call!(zip:)
          raise ArgumentError.new("Zip can't be blank") if zip.blank?

          new(zip).call!
        end

        def call!
          @response = HTTParty.get(url, headers: headers) # HTTParty::Error
          parsed_response
        rescue HTTParty::Error => error
          Rails.logger.error(error.message)
          raise error
        end

        private

        def parsed_response
          return response.parsed_response.symbolize_keys if [200].include?(response.code)

          Rails.logger.error({ from: "Latech::Cepla::Http::Services::GetAddress.call!(zip:#{zip})", code: response.code, body: response.body })
          raise StandardError.new(I18n.t(:error_on_http_service_from_address_capture))
        end
      end
    end
  end
end
