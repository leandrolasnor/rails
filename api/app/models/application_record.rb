# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include LiberalEnum
  self.abstract_class = true

  connects_to database: {
    writing: :primary,
    reading: :primary_replica
  }

  def self.reader
    ActiveRecord::Base.connected_to(role: :reading, prevent_writes: true) do
      yield
    end
  end
end
