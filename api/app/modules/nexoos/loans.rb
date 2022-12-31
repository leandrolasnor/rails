# frozen_string_literal: true

module ::Nexoos
  module Loans
    class << self
      attr_reader :params

      def show(params)
        user = params.fetch(:user)
        id = params.fetch(:id)
        yield(
          ApplicationRecord.reader do
            loan = user.loans.find(id) # ActiveRecord::RecordNotFound
            Nexoos::LoanSerializer.new(loan).serializable_hash
          end
        )
      rescue ActiveRecord::RecordNotFound => error
        yield(nil, [error.message])
      end

      def create(params)
        record = Factory.make(params)
        yield(record, nil)
      rescue ActiveRecord::RecordInvalid => error
        yield(nil, error.record.errors.full_messages)
      end

      def search(params)
        yield(
          Nexoos::Loan.search(
            query: params.fetch(:query, ''),
            params: {
              limit: params.dig(:pagination, :limit),
              offset: params.dig(:pagination, :offset),
              sort: ['created_at:desc']
            }
          )
        )
      rescue StandardError => error
        yield(nil, [error.message])
      end

      module Factory
        class << self
          def make(params)
            Nexoos::Loan.create! do |l|
              l.rate      = params.fetch(:rate)
              l.nper      = params.fetch(:nper)
              l.pv        = params.fetch(:pv)
              l.user      = params.fetch(:user)
            end
          end
        end
      end
    end
  end
end
