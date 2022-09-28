# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Cepla::Http, type: :context do
  context 'on allowed services' do
    let(:allowed_services) { [:get_address] }

    it do
      expect(described_class.allowed_services == allowed_services).to be_truthy
    end
  end


  context 'on prepend' do
    context 'on success' do

      before do
        Latech::Cepla::Http::Services::GetAddress.prepend(described_class)
      end

      it do
        expect(Latech::Cepla::Http::Services::GetAddress.ancestors.first).to be(described_class)
      end
    end

    context 'on exception' do
      let(:object) { double }

      it 'raise a Standard Error' do
        expect { object.class.prepend(described_class) }.to raise_error(StandardError)
      end
    end
  end
end
