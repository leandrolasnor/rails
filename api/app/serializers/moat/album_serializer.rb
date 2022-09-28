# frozen_string_literal: true

module ::Moat
  class AlbumSerializer < ActiveModel::Serializer
    attributes :id, :name, :year, :artist
  end
end
