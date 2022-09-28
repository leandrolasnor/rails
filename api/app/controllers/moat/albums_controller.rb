# frozen_string_literal: true

module ::Moat
  class AlbumsController < ApiController
    def search
      authorize!(:read, Moat::Album)
      deliver(Moat::SearchAlbumsService.call(album_search_params))
    end

    def show
      authorize!(:read, Album)
      deliver(Moat::ShowAlbumService.call(album_show_params))
    end

    def create
      authorize!(:create, Album)
      deliver(Moat::CreateAlbumService.call(album_create_params))
    end

    def update
      authorize!(:update, Album)
      deliver(Moat::UpdateAlbumService.call(album_update_params))
    end

    def destroy
      authorize!(:destroy, Album)
      deliver(Moat::RemoveAlbumService.call(album_destroy_params))
    end

    private

    def album_params
      params.fetch(:album, {}).merge(pagination_params).merge(channel_params)
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
      album_params[:pagination][:serializer] = AlbumsSerializer
      album_params.merge(query: params[:query]).permit(:query, :channel, { pagination: [:current_page, :per_page, :serializer] })
    end
  end
end
