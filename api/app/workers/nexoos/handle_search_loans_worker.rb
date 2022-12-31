# frozen_string_literal: true

module ::Nexoos
  class HandleSearchLoansWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Nexoos::Loans.search(params) do |loans, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'LOANS_FETCHED', payload: { loans: loans } }) if loans.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_LOANS_FETCHED', payload: { errors: errors } }) if errors.present?
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
