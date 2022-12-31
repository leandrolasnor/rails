# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Republic::Wall do
  subject do
    described_class.new(
      {
        height: 3,
        width: 5,
        doors_count: 1,
        windows_count: 1
      }
    )
  end

  it { is_expected.to validate_numericality_of(:width) }
  it { is_expected.to validate_numericality_of(:height) }
  it { is_expected.to validate_numericality_of(:windows_count) }
  it { is_expected.to validate_numericality_of(:doors_count) }
  it { is_expected.to delegate_method(:area).to(:geometric) }
  it { is_expected.to respond_to(:area) }
  it { is_expected.to delegate_method(:doors_area).to(:geometric) }
  it { is_expected.to respond_to(:doors_area) }
  it { is_expected.to delegate_method(:windows_area).to(:geometric) }
  it { is_expected.to respond_to(:windows_area) }
  it { is_expected.to delegate_method(:anpaintable_area_ratio).to(:geometric) }
  it { is_expected.to respond_to(:anpaintable_area_ratio) }
end
