# frozen_string_literal: true

module ::Republic
  class Paintable
    include ActiveModel::Validations

    attr_reader :halls

    validates_with Republic::TriggerValidator

    delegate :area, to: :geometric

    def initialize(params)
      @halls = []
      params.fetch(:halls).each do |hall_attributes|
        @halls << Republic::Hall.new(hall_attributes)
      end
    end

    private

    def geometric
      @geometric ||= Republic::Geometric::Paintable.new(self)
    end
  end
end
