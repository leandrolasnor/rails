# frozen_string_literal: true

module ::Republic
  class WallsQuantityLimitValidator < ActiveModel::Validator
    def validate(record)
      unless (1..4).cover?(record.walls.length)
        record.errors.add(:base, I18n.t(:walls_quantity_limit))
      end
    end
  end
end
