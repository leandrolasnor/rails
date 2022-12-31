# frozen_string_literal: true

module ::Nexoos
  class HandleCreateLoanWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.create(params) do |loan, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'LOAN_CREATED', payload: { loan: loan } }) if loan.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_LOAN_CREATED', payload: { errors: errors } }) if errors.present?
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
