# frozen_string_literal: true

module ::Nexoos
  class HandleCreateLoanWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.create(params) do |loan, errors|
        if loan.present?
          broker(params[:channel]) do
            { type: 'LOAN_CREATED', payload: { loan: loan } }
          end
        elsif errors.present?
          broker(params[:channel]) do
            { type: 'ERRORS_FROM_LOAN_CREATED', payload: { errors: errors } }
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
