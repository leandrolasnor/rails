# frozen_string_literal: true

module ::Moat
  class HandleShowAlbumWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Moat::Albums.show(params) do |album, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'ALBUM_FETCHED', payload: { album: album } }) if album.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_ALBUM_FETCHED', payload: { errors: errors } }) if errors.present?
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
