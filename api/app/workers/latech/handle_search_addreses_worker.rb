# frozen_string_literal: true

module ::Latech
  class HandleSearchAddresesWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Latech::Addreses.search(params) do |addreses, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'ADDRESES_FETCHED', payload: addreses }) if addreses.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_ADDRESES_FETCHED', payload: { errors: errors } }) if errors.present?
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
