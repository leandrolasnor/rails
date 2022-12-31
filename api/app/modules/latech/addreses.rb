# frozen_string_literal: true

module ::Latech
  module Addreses
    class << self
      def make_sure_assignment(params)
        assignment = ActiveRecord::Base.transaction do
          Latech::AddressAssignment.create! do |a|
            a.user_id = params.fetch(:user_id)
            a.address_id = params.fetch(:address_id)
            break if a.assigned?
          end
        end
        yield(assignment)
      rescue ActiveRecord::RecordInvalid => error
        yield(nil, error.record.errors.full_messages)
      rescue StandardError => error
        yield(nil, error.message)
      end

      def search(params)
        yield(
          Latech::Address.search(
            query: params.fetch(:query, ''),
            params: {
              filter: ["user = '#{params.fetch(:user_id)}'"],
              limit: params.dig(:pagination, :limit),
              offset: params.dig(:pagination, :offset),
              sort: ['address:asc']
            }
          )
        )
      rescue StandardError => error
        yield(nil, [error.message])
      end

      def capture(params)
        captured_address = ActiveRecord::Base.transaction do
          Latech::Address.create! do |a| # ActiveRecord::RecordInvalid
            a.zip = params.fetch(:zip) # KeyError # StandardError
            a.capture do |address| # HTTParty::Error
              a.address = address.fetch(:logradouro)
              a.district = address.fetch(:bairro)
              a.city = address.fetch(:cidade)
              a.state = address.fetch(:uf)
            end
            a.address_assignments << Latech::AddressAssignment.new(user_id: params.fetch(:user_id))
          end
        end
        yield(captured_address)
      rescue ActiveRecord::RecordInvalid => error
        yield(nil, error.record.errors.full_messages)
      rescue HTTParty::Error
        yield(nil, [I18n.t(:error_on_http_service_from_address_capture)])
      rescue StandardError => error
        yield(nil, [error.message])
      end
    end
  end
end
