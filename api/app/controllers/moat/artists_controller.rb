# frozen_string_literal: true

module ::Moat
  class ArtistsController < ApiController
    def index
      authorize!(:create, Album)
      deliver(Moat::GetArtistsService.call(index_param))
    end

    private

    def artist_params
      params.fetch(:artist, {}).merge(pagination_params).merge(channel_params)
    end

    def index_param
      artist_params.permit(:channel)
    end
  end
end
