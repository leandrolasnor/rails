# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Paintable do
  subject { described_class.new(attributes) }

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

  describe '.trigger_validator' do
    context 'when parameters are correct' do
      it { is_expected.to be_valid }
    end

    context 'when parameters are not correct' do
      let(:attributes) do
        {
          halls: [
            {
              walls: [
                {
                  height: 1,
                  width: 1,
                  doors_count: 1,
                  windows_count: 0
                }
              ]
            }
          ]
        }
      end

      it { is_expected.not_to be_valid }
    end

    describe '.respond_to' do
      it { is_expected.to delegate_method(:area).to(:geometric) }
      it { is_expected.to respond_to(:area) }
    end
  end
end
