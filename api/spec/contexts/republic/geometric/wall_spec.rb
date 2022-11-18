# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Geometric::Wall do
  subject { described_class.new(Wall.new(attributes)) }

  describe '.area' do
    context 'when there are doors and windows on walls' do
      let(:attributes) do
        {
          height: 2.5,
          width: 5,
          doors_count: 1,
          windows_count: 1
        }
      end
      let(:expected_area) { 12.5 }

      it { expect(subject.area).to eq(expected_area) }
    end

    context 'when there are not doors or windows on walls' do
      let(:attributes) do
        {
          height: 1,
          width: 1,
          doors_count: 0,
          windows_count: 0
        }
      end
      let(:expected_area) { 1 }

      it { expect(subject.area).to eq(expected_area) }
    end
  end

  describe '.doors_area' do
    context 'when there are doors on walls' do
      let(:attributes) do
        {
          height: 2.5,
          width: 5,
          doors_count: 2,
          windows_count: 1
        }
      end
      let(:expected_doors_area) { 3.04 }

      it { expect(subject.doors_area).to eq(expected_doors_area) }
    end

    context 'when there are not doors on walls' do
      let(:attributes) do
        {
          height: 1,
          width: 1,
          doors_count: 0,
          windows_count: 0
        }
      end
      let(:expected_doors_area) { 0 }

      it { expect(subject.doors_area).to eq(expected_doors_area) }
    end
  end

  describe '.windows_area' do
    context 'when there are windows on walls' do
      let(:attributes) do
        {
          height: 2.5,
          width: 5,
          doors_count: 2,
          windows_count: 2
        }
      end
      let(:expected_windows_area) { 4.8 }

      it { expect(subject.windows_area).to eq(expected_windows_area) }
    end

    context 'when there are not windows on walls' do
      let(:attributes) do
        {
          height: 1,
          width: 1,
          doors_count: 0,
          windows_count: 0
        }
      end
      let(:expected_windows_area) { 0 }

      it { expect(subject.windows_area).to eq(expected_windows_area) }
    end
  end

  describe '.anpaintable_area_ratio' do
    context 'when there are doors and windows on walls' do
      let(:attributes) do
        {
          height: 2.5,
          width: 5,
          doors_count: 1,
          windows_count: 1
        }
      end
      let(:expected_anpaintable_area_ratio) { 0.3136 }

      it { expect(subject.anpaintable_area_ratio).to eq(expected_anpaintable_area_ratio) }
    end

    context 'when there are not doors or windows on walls' do
      let(:attributes) do
        {
          height: 1,
          width: 1,
          doors_count: 0,
          windows_count: 0
        }
      end
      let(:expected_anpaintable_area_ratio) { 0.0 }

      it { expect(subject.anpaintable_area_ratio).to eq(expected_anpaintable_area_ratio) }
    end
  end
end
