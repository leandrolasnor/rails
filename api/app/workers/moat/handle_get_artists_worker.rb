# frozen_string_literal: true

module ::Moat
  class HandleGetArtistsWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      artists = Moat::Artist.all
      broker(params[:channel]) do
        { type: 'ARTISTS_FETCHED', payload: { artists: artists } }
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
