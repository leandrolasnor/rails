# frozen_string_literal: true

class HandleCreateAlbumWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(params)
    params = params.deep_symbolize_keys!
    Albums.create(params) do |album, errors|
      ActionCable.server.broadcast(params[:channel], { type: 'ALBUM_CREATED', payload: { album: album } }) if album.present?
      ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_ALBUM_CREATED', payload: { errors: errors } }) if errors.present?
    end
  rescue StandardError => error
    Rails.logger.error(error.inspect)
    ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: 'HTTP 500 Internal Server Error' } })
  end
end
