# frozen_string_literal: true

class AlbumsSerializer < ActiveModel::Serializer
  attributes :id, :name, :year
end
