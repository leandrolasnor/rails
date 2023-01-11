# frozen_string_literal: true

module ::Nexoos
  class HandleSearchLoansWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.search(params) do |loans, errors|
        if loans.present?
          broker(params[:channel]) do
            { type: 'LOANS_FETCHED', payload: { loans: loans } }
          end
        elsif errors.present?
          broker(params[:channel]) do
            { type: 'ERRORS_FROM_LOANS_FETCHED', payload: { errors: errors } }
          end
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
      broker(params[:channel]) do
        {
          type: '500',
          payload: { message: I18n.t(:message_internal_server_error) }
        }
      end
    end
  end
end
