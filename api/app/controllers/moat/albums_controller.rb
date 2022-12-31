# frozen_string_literal: true

module ::Moat
  class AlbumsController < ApiController
    def search
      authorize!(:read, Moat::Album)
      deliver(Moat::SearchAlbumsService.call(album_search_params))
    end

    def show
      authorize!(:read, Moat::Album)
      deliver(Moat::ShowAlbumService.call(album_show_params))
    end

    def create
      authorize!(:create, Moat::Album)
      deliver(Moat::CreateAlbumService.call(album_create_params))
    end

    def update
      authorize!(:update, Moat::Album)
      deliver(Moat::UpdateAlbumService.call(album_update_params))
    end

    def destroy
      authorize!(:destroy, Moat::Album)
      deliver(Moat::RemoveAlbumService.call(album_destroy_params))
    end

    private

    def album_params
      params.fetch(:album, {}).merge(channel_params)
    end

    def album_show_params
      album_params.merge(id: params[:id]).permit(:id, :channel)
    end

    def album_create_params
      album_params.permit(:name, :year, :artist_id, :channel)
    end

    def album_destroy_params
      album_params.merge(id: params[:id]).permit(:id, :channel)
    end

    def album_update_params
      album_params.merge(id: params[:id]).permit(:id, :name, :year, :artist_id, :channel)
    end

    def album_search_params
      album_params.merge(
        search_pagination_params
      ).merge(
        query: params.fetch(:query, '')
      ).permit(
        :query,
        :channel,
        {
          pagination: [
            :limit,
            :offset
          ]
        }
      )
    end
  end
end
