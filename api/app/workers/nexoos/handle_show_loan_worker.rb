# frozen_string_literal: true

module ::Nexoos
  class HandleShowLoanWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.show(params) do |loan, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'LOAN_FETCHED', payload: { loan: loan } }) if loan.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_LOAN_FETCHED', payload: { errors: errors } }) if errors.present?
        cached_loan(loan.presence)
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end

    private

    def cached_loan(loan)
      Rails.cache.fetch("#{__method__}/#{params.fetch(:id)}", expire_in: 12.hours, skip_nil: true) do
        { type: 'LOAN_FETCHED', payload: { loan: loan } } if loan.present?
      end
    end
  end
end
