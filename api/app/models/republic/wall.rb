# frozen_string_literal: true

module ::Republic
  class Wall
    include ActiveModel::Validations

    attr_accessor :height
    attr_accessor :width
    attr_accessor :doors_count
    attr_accessor :windows_count

    delegate :area, to: :geometric
    delegate :doors_area, to: :geometric
    delegate :windows_area, to: :geometric
    delegate :anpaintable_area_ratio, to: :geometric

    validates :height, numericality: { greater_than: 0 }, format: { with: /\A(?:[1-9]+[0-9]*|0)(?:\.[0-9]{1,2})?\z/, message: I18n.t(:bad_formatted) }
    validates :width, numericality: { greater_than: 0 }, format: { with: /\A(?:[1-9]+[0-9]*|0)(?:\.[0-9]{1,2})?\z/, message: I18n.t(:bad_formatted) }
    validates :windows_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates :doors_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
    validates_with AreaLimitValidator
    validates_with HeightWallAndDoorsValidator, if: -> { doors_count.to_i.positive? }
    validates_with WindowsAndDoorsAreaRatioValidator, if: -> { windows_area.positive? && doors_area.positive? && area.positive? }

    def initialize(attributes)
      @height = attributes.fetch(:height)
      @width = attributes.fetch(:width)
      @doors_count = attributes.fetch(:doors_count)
      @windows_count = attributes.fetch(:windows_count)
    end

    private

    def geometric
      @geometric ||= Geometric::Wall.new(self)
    end
  end
end
