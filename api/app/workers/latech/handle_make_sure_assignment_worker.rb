# frozen_string_literal: true

module ::Latech
  class HandleMakeSureAssignmentWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Latech::Addreses.make_sure_assignment(params) do |_, errors|
        if errors.present?
          broker(params[:channel]) do
            {
              type: 'ERRORS_FROM_MAKE_SURE_ASSIGNMENT',
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
