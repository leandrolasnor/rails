# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Republic::CalculatePaintableArea, type: :module do
  describe '#from' do
    subject { described_class.from(params) }

    context 'with invalid params' do
      let(:params) do
        {
          halls: [
            {
              walls: [
                {
                  height: 0,
                  width: 0,
                  doors_count: -1,
                  windows_count: -1
                }
              ]
            }
          ]
        }
      end

      it 'must be raise Republic::ConfigInvalid exception' do
        expect { subject }.to raise_error(Republic::ConfigInvalid)
      end
    end
  end
end
