# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wall do
  subject { described_class.new(attributes) }

  let(:attributes) do
    {
      height: 1,
      width: 1,
      doors_count: 0,
      windows_count: 0
    }
  end

  it { is_expected.to validate_numericality_of(:width) }
  it { is_expected.to validate_numericality_of(:height) }
  it { is_expected.to validate_numericality_of(:windows_count) }
  it { is_expected.to validate_numericality_of(:doors_count) }

  describe '.area_limit_validator' do
    context 'when wall area within of bounds' do
      it { is_expected.to be_valid }
    end

    context 'when wall area out of bounds' do
      let(:attributes) do
        {
          height: 5,
          width: 10.01,
          doors_count: 1,
          windows_count: 0
        }
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe '.height_wall_and_doors_validator' do
    context 'when wall have not a door' do
      it { is_expected.to be_valid }
    end

    context 'when wall have a door and appropriate height' do
      let(:attributes) do
        {
          height: 2.2,
          width: 1,
          doors_count: 1,
          windows_count: 0
        }
      end

      it { is_expected.to be_valid }
    end

    context 'when wall have a door and have not a appropriate height' do
      let(:attributes) do
        {
          height: 1.9,
          width: 1,
          doors_count: 1,
          windows_count: 0
        }
      end

      it { is_expected.not_to be_valid }
    end
  end

  describe '.windows_and_doors_area_ratio_validator' do
    context 'when there are not any doors or windows on wall' do
      it { is_expected.to be_valid }
    end

    context 'when there is not a appropriate ratio between doors windows and wall area' do
      let(:attributes) do
        {
          height: 2.2,
          width: 1,
          doors_count: 1,
          windows_count: 1
        }
      end

      it { is_expected.not_to be_valid }
    end

    context 'when there is a appropriate ratio between doors windows and wall area' do
      let(:attributes) do
        {
          height: 2.2,
          width: 3.8,
          doors_count: 1,
          windows_count: 1
        }
      end

      it { is_expected.to be_valid }
    end
  end

  describe '.respond_to' do
    it { is_expected.to delegate_method(:area).to(:geometric) }
    it { is_expected.to respond_to(:area) }
    it { is_expected.to delegate_method(:doors_area).to(:geometric) }
    it { is_expected.to respond_to(:doors_area) }
    it { is_expected.to delegate_method(:windows_area).to(:geometric) }
    it { is_expected.to respond_to(:windows_area) }
    it { is_expected.to delegate_method(:anpaintable_area_ratio).to(:geometric) }
    it { is_expected.to respond_to(:anpaintable_area_ratio) }
  end
end
