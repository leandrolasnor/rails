# frozen_string_literal: true

module ::Moat
  class ArtistsController < ApiController
    def index
      authorize!(:create, Album)
      deliver(Moat::GetArtistsService.call(index_params))
    end

    private

    def artist_params
      params.fetch(:artist, {})
    end

    def index_params
      artist_params.merge(channel_params).permit(:channel)
    end
  end
end
