# frozen_string_literal: true

module ::Latech
  class HandleSearchAddresesWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Latech::Addreses.search(params) do |addreses, errors|
        if addreses.present?
          broker(params[:channel]) do
            { type: 'ADDRESES_FETCHED', payload: { addreses: addreses } }
          end
        elsif errors.present?
          broker(params[:channel]) do
            {
              type: 'ERRORS_FROM_ADDRESES_FETCHED',
              payload: { errors: errors }
            }
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
