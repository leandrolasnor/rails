# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Cepla::Address, type: :context do
  let(:address) { create(:address) }
  let(:address_contextualized) { described_class.new(address) }

  context 'on success' do
    before do
      allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: address.zip).and_return(true)
    end

    it 'must return a captured address' do
      expect { |b| address_contextualized.capture(&b) }.to yield_with_args(true)
    end
  end
end
