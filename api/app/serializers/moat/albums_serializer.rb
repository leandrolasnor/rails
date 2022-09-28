# frozen_string_literal: true

module ::Moat
  class AlbumsSerializer < ActiveModel::Serializer
    attributes :id, :name, :year
  end
end
