# frozen_string_literal: true

class HandleShowAlbumWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(params)
    params = params.deep_symbolize_keys!
    Albums.show(params) do |album, errors|
      ActionCable.server.broadcast(params[:channel], { type: 'ALBUM_FETCHED', payload: { album: album } }) if album.present?
      ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_ALBUM_FETCHED', payload: { errors: errors } }) if errors.present?
    end
  rescue StandardError => error
    Rails.logger.error(error.inspect)
    ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: 'HTTP 500 Internal Server Error' } })
  end
end
