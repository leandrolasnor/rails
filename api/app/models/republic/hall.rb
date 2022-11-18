# frozen_string_literal: true

module ::Republic
  class Hall
    include ActiveModel::Validations
    attr_reader :walls

    delegate :paintable_area, to: :geometric

    validates_with WallsQuantityLimitValidator

    def initialize(attributes)
      @walls = []
      attributes.fetch(:walls).each do |attr|
        @walls << Wall.new(attr)
      end
    end

    private

    def geometric
      @geometric ||= Geometric::Hall.new(self)
    end
  end
end
