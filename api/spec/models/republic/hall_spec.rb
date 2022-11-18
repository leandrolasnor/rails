# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hall do
  subject { described_class.new(attributes) }

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

  describe '.walls_quantity_limit_validator' do
    context 'when quantity of walls inside a hall is between one and four' do
      it { is_expected.to be_valid }
    end

    context 'when quantity of walls inside a hall is greater then four' do
      let(:attributes) do
        {
          walls: [
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            },
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            },
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            },
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            },
            {
              height: 1,
              width: 1,
              doors_count: 0,
              windows_count: 0
            }
          ]
        }
      end

      it { is_expected.not_to be_valid }
    end

    context 'when quantity of walls inside a hall is smaller than one' do
      let(:attributes) { { walls: [] } }

      it { is_expected.not_to be_valid }
    end
  end

  describe '.respond_to' do
    it { is_expected.to delegate_method(:paintable_area).to(:geometric) }
    it { is_expected.to respond_to(:paintable_area) }
  end
end
