# frozen_string_literal: true

module ::Moat
  class HandleSearchAlbumsWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Moat::Albums.search(params) do |albums, errors|
        if albums.present?
          broker(params[:channel]) do
            { type: 'ALBUMS_FETCHED', payload: { albums: albums } }
          end
        elsif errors.present?
          broker(params[:channel]) do
            { type: 'ERRORS_FROM_SEARCH_ALBUMS', payload: { errors: errors } }
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
