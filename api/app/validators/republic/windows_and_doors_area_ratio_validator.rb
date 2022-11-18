# frozen_string_literal: true

class WindowsAndDoorsAreaRatioValidator < ActiveModel::Validator
  def validate(record)
    if record.anpaintable_area_ratio > ENV.fetch('REPUBLIC_WINDOWS_DOORS_WALL_AREA_RATIO_LIMIT').to_f
      record.errors.add(:base, I18n.t(:windows_and_doors_limit_area))
    end
  end
end
