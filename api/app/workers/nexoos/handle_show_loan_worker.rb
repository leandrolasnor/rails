# frozen_string_literal: true

module ::Nexoos
  class HandleShowLoanWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.show(params) do |loan, errors|
        if loan.present?
          broker(params[:channel]) do
            cached_loan(loan)
          end
        elsif errors.present?
          broker(params[:channel]) do
            { type: 'ERRORS_FROM_LOAN_FETCHED', payload: { errors: errors } }
          end
        end
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      broker(params[:channel]) do
        {
          type: '500',
          payload: { message: I18n.t(:message_internal_server_error) }
        }
      end
    end

    private

    def cached_loan(loan)
      key = "#{__method__}/#{params.fetch(:id)}"
      params = { expire_in: 12.hours, skip_nil: true }
      Rails.cache.fetch(key, params) do
        { type: 'LOAN_FETCHED', payload: { loan: loan } }
      end
    end
  end
end
