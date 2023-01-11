# frozen_string_literal: true

module ::Latech
  class HandleCaptureAddressWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Latech::Addreses.capture(params) do |address, errors|
        if address.present?
          ActionCable.server.broadcast(
            params[:channel],
            {
              type: 'CAPTURED_ADDRESS',
              payload: { address: address }
            }
          )
        elsif errors.present?
          ActionCable.server.broadcast(
            params[:channel],
            {
              type: 'ERRORS_FROM_CAPTURED_ADDRESS',
              payload: { errors: errors }
            }
          )
        end
      end
    rescue StandardError => error
      Rails.logger.error(error)
      ActionCable.server.broadcast(
        params[:channel],
        {
          type: '500',
          payload: { message: I18n.t(:message_internal_server_error) }
        }
      )
    end
  end
end
