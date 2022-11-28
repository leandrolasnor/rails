# frozen_string_literal: true

module ::Republic
  class Hall
    include ActiveModel::Validations
    attr_reader :walls

    delegate :paintable_area, to: :geometric

    validates_with Republic::WallsQuantityLimitValidator

    def initialize(attributes)
      @walls = []
      attributes.fetch(:walls).each do |attr|
        @walls << Republic::Wall.new(attr)
      end
    end

    private

    def geometric
      @geometric ||= Republic::Geometric::Hall.new(self)
    end
  end
end
