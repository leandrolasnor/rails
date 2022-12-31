# frozen_string_literal: true

module ::Moat
  class Album < ApplicationRecord
    include MeiliSearch::Rails
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :album do
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

    delegate :artist, to: :moat

    validates :name, presence: true
    validates :artist_id, presence: true
    validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1948 }, presence: true

    default_scope { order(created_at: :desc) }

    private

    def moat
      @moat ||= Moat::Api::Album.new(self)
    end
  end
end
