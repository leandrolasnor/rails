# frozen_string_literal: true

module ::Republic
  class HeightWallAndDoorsValidator < ActiveModel::Validator
    def validate(record)
      if record.height.to_f < ENV.fetch('REPUBLIC_DOOR_HEIGHT').to_f + 0.3
        record.errors.add(:base, I18n.t(:wall_with_doors_height_limit))
      end
    end
  end
end
