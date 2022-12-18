# frozen_string_literal: true

module ::Moat
  module Search
    class Album < Moat::Album
      include MeiliSearch::Rails

      after_touch :index!

      meilisearch index_uid: Rails.env.test? ? :_album : :album do
        attribute :name
        attribute :year
        attribute :artist do
          artist[:name]
        end
        attribute :twitter do
          artist[:twitter]
        end
        displayed_attributes [:id, :name, :year]
        searchable_attributes [:name, :year, :artist, :twitter]
        sortable_attributes [:name]
      end

      def self.search(query: '', params: {})
        Meilisearch::Index.album do |index|
          index.search(query, params).deep_symbolize_keys!
        end
      end
    end
  end
end
