# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Geometric::Hall do
  subject { described_class.new(Hall.new(attributes)) }

  describe '.paintable_area' do
    context 'when there are doors and windows on walls' do
      let(:attributes) do
        {
          walls: [
            {
              height: 2.5,
              width: 5,
              doors_count: 1,
              windows_count: 1
            }
          ]
        }
      end
      let(:expected_paintable_area) { 8.58 }

      it { expect(subject.paintable_area).to eq(expected_paintable_area) }
    end

    context 'when there are not doors or windows on walls' do
      let(:attributes) do
        {
          walls: [
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            }
          ]
        }
      end
      let(:expected_paintable_area) { 1 }

      it { expect(subject.paintable_area).to eq(expected_paintable_area) }
    end
  end
end
