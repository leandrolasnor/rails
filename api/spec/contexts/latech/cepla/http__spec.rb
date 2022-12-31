# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Cepla::Http, type: :context do
  context 'with allowed services' do
    let(:expected_allowed_services) { [:get_address] }

    it 'must to allow' do
      expect(described_class.allowed_services).to eq(expected_allowed_services)
    end
  end

  describe '.prepend' do
    context 'on success' do
      before do
        Latech::Cepla::Http::Services::GetAddress.prepend(described_class)
      end

      it 'must to prepend' do
        expect(Latech::Cepla::Http::Services::GetAddress.ancestors.first).to be(described_class)
      end
    end

    context 'on exception' do
      let(:object) { double }

      it 'must to raise a Standard Error' do
        expect { object.class.prepend(described_class) }.to raise_error(StandardError)
      end
    end
  end
end
