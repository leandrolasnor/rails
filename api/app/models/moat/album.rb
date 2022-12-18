# frozen_string_literal: true

module ::Moat
  class Album < ApplicationRecord
    self.abstract_class = true

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
