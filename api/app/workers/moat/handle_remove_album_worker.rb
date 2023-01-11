# frozen_string_literal: true

module ::Moat
  class HandleRemoveAlbumWorker
    include Sidekiq::Worker
    include Broker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Moat::Albums.delete(params) do |album, errors|
        if album.present?
          broker(params[:channel]) do
            { type: 'ALBUM_REMOVED', payload: { album: album } }
          end
        elsif errors.present?
          broker(params[:channel]) do
            { type: 'ERRORS_FROM_ALBUM_REMOVED', payload: { errors: errors } }
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
