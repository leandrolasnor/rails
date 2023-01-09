# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Republic::Geometric::Hall do
  describe '.paintable_area' do
    subject { hall.paintable_area }

    let(:hall) { Republic::Hall.new(attributes) }

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

      it { is_expected.to eq(expected_paintable_area) }
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

      it { is_expected.to eq(expected_paintable_area) }
    end
  end
end
