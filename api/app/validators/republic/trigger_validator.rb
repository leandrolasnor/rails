# frozen_string_literal: true

module ::Republic
  class TriggerValidator < ActiveModel::Validator
    def validate(record)
      record.halls&.each do |hall|
        hall.walls.each do |wall|
          record.errors.add(:base, wall.errors.full_messages) if wall.invalid?
        end
        record.errors.add(:base, hall.errors.full_messages) if hall.invalid?
      end
    end
  end
end
