# frozen_string_literal: true

module ::Moat
  module Albums
    class << self
      attr_reader :params

      def show(params)
        album = ApplicationRecord.reader do
          Moat::AlbumSerializer.new(Moat::Search::Album.find(params.fetch(:id))).serializable_hash # ActiveRecord::RecordNotFound
        end
        yield(album, nil)
      rescue ActiveRecord::RecordNotFound => error
        yield(nil, [error.message])
      end

      def create(params)
        album = Factory.make(params)
        yield(album, nil)
      rescue ActiveRecord::RecordInvalid => error
        yield(nil, error.record.errors.full_messages)
      end

      def update(params)
        album = ApplicationRecord.reader do
          Moat::Search::Album.find(params[:id]) # ActiveRecord::RecordNotFound
        end
        album.update!(params.slice(:name, :year, :artist_id))
        yield(album, nil)
      rescue ActiveRecord::RecordInvalid => error
        yield(nil, error.record.errors.full_messages)
      rescue ActiveRecord::RecordNotFound => error
        yield(nil, [error.message])
      end

      def search(params)
        albums = Moat::Search::Album.search(
          query: params.fetch(:query, ''),
          params: {
            limit: params.dig(:pagination, :limit),
            offset: params.dig(:pagination, :offset),
            sort: ['name:asc']
          }
        )
        yield(albums, nil)
      rescue StandardError => error
        yield(nil, [error.message])
      end

      def delete(params)
        deleted = Sweeper.make(params)
        yield(deleted, nil)
      rescue ActiveRecord::RecordNotDestroyed => error
        yield(nil, error.record.errors.full_messages)
      rescue ActiveRecord::RecordNotFound => error
        yield(nil, [error.message])
      end
    end

    module Sweeper
      class << self
        def make(params)
          album = ApplicationRecord.reader do
            Moat::Search::Album.find(params[:id]) # ActiveRecord::RecordNotFound
          end
          album.destroy! # ActiveRecord::RecordNotDestroyed
        end
      end
    end

    module Factory
      class << self
        def make(params)
          album = Moat::Search::Album.new do |s|
            s.name      = params[:name]
            s.year      = params[:year]
            s.artist_id = params[:artist_id]
          end
          album.save!
          album
        end
      end
    end
  end
end
