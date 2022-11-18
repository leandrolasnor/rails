# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Geometric::Paintable do
  subject { described_class.new(Paintable.new(attributes)) }

  describe '.area' do
    context 'when there are doors and windows on wall' do
      let(:attributes) do
        {
          halls: [
            {
              walls: [
                {
                  height: 2.5,
                  width: 5,
                  doors_count: 0,
                  windows_count: 1
                },
                {
                  height: 2.5,
                  width: 5,
                  doors_count: 1,
                  windows_count: 1
                }
              ]
            }
          ]
        }
      end
      let(:expected_area) { 18.68 }

      it { expect(subject.area).to eq(expected_area) }
    end

    context 'when there are not doors or windows on wall' do
      let(:attributes) do
        {
          halls: [
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
          ]
        }
      end
      let(:expected_area) { 1 }

      it { expect(subject.area).to eq(expected_area) }
    end
  end
end
