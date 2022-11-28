# frozen_string_literal: true

module ::Republic
  class AreaLimitValidator < ActiveModel::Validator
    def validate(record)
      unless (1..50).cover?(record.area)
        record.errors.add(:base, I18n.t(:wall_area_limit))
      end
    end
  end
end
