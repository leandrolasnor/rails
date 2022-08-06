# frozen_string_literal: true

class Moat::ArtistsController < ApiController
  def list
    authorize!(:create, Album)
    deliver(GetArtistsService.call(list_param))
  end

  private

  def artist_params
    params.fetch(:artist, {}).merge(pagination_params).merge(channel_params)
  end

  def list_param
    artist_params.permit(:channel)
  end
end
