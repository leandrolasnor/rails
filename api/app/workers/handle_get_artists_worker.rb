# frozen_string_literal: true

class HandleGetArtistsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(params)
    params = params.deep_symbolize_keys!
    artists = Moat::Api::Artist.all
    ActionCable.server.broadcast(params[:channel], { type: 'ARTISTS_FETCHED', payload: { artists: artists } })
  rescue StandardError => error
    Rails.logger.error(error.inspect)
    ActionCable.server.broadcast(params[:channel], { type: '500', payload: { message: 'HTTP 500 Internal Server Error' } })
  end
end
