# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include LiberalEnum
  self.abstract_class = true
end
