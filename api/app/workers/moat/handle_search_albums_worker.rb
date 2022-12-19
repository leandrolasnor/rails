# frozen_string_literal: true

module ::Moat
  class HandleSearchAlbumsWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      Moat::Albums.search(params) do |albums, errors|
        ActionCable.server.broadcast(params[:channel], { type: 'ALBUMS_FETCHED', payload: { albums: albums } }) if albums.present?
        ActionCable.server.broadcast(params[:channel], { type: 'ERRORS_FROM_SEARCH_ALBUMS', payload: { errors: errors } }) if errors.present?
      end
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
