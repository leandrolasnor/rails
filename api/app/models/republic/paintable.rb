# frozen_string_literal: true

module ::Republic
  class Paintable
    include ActiveModel::Validations

    attr_reader :halls

    validates_with TriggerValidator

    delegate :area, to: :geometric

    def initialize(params)
      @halls = []
      params.fetch(:halls).each do |hall_attributes|
        @halls << Hall.new(hall_attributes)
      end
    end

    private

    def geometric
      @geometric ||= Geometric::Paintable.new(self)
    end
  end
end
