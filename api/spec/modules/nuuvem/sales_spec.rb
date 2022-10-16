# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nuuvem::Sales, type: :module do
  context 'on create' do
    let(:file) { fixture_file_upload('files/example_input.tab', 'text/xml') }
    let(:params) { { name: 'name', path: 'path', file: file } }
    let(:params_invalid) { { name: '', path: '', file: nil } }

    it 'must to create a new sale with success' do
      described_class.create!(params) do |instance, errors|
        expect(instance).to be_a(Nuuvem::Sale)
        expect(errors).to be_nil
      end
    end

    context 'when create raise error' do
      it 'fields are invalid' do
        described_class.create!(params_invalid) do |instance, errors|
          expect(instance).to be_nil
          expect(errors).to be_a(Array)
        end
      end
    end

    context 'when create raise a StandardError' do
      let(:error) { StandardError.new('Some error') }

      before do
        allow(Nuuvem::Sales::Factory).to receive(:make).with(params_invalid).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.create!(params_invalid) }.to raise_error(StandardError, 'Some error')
      end
    end
  end
end
