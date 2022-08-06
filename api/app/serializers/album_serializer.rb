# frozen_string_literal: true

class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist
end
