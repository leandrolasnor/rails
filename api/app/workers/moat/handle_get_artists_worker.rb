# frozen_string_literal: true

module ::Moat
  class HandleGetArtistsWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(params)
      params = params.deep_symbolize_keys!
      artists = Moat::Api::Artist.all
      ActionCable.server.broadcast(params[:channel], { type: 'ARTISTS_FETCHED', payload: { artists: artists } })
    rescue StandardError => error
      Rails.logger.error(error.message)
      ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: I18n.t(:message_internal_server_error) } })
    end
  end
end
