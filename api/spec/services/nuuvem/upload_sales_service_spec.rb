# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nuuvem::UploadSalesService, type: :service do
  context 'when calling the service' do
    let(:params) { 'params' }
    let(:service) { described_class.call(params) }
    let(:expected_sales_file) { create(:sales_file) }

    context 'on success' do
      before do
        allow(Nuuvem::Sales).to receive(:create!).with(params).and_yield(expected_sales_file)
        allow(Nuuvem::HandleSaleFileNormalizationWorker).to receive(:perform_async).with(expected_sales_file.path)
      end

      it 'must to return successful body content' do
        expect(service).to eq successful_response
        expect(Nuuvem::Sales).to have_received(:create!).with(params)
        expect(Nuuvem::HandleSaleFileNormalizationWorker).to have_received(:perform_async).with(expected_sales_file.path)
      end
    end

    context 'on error' do
      let(:error) { StandardError.new('Error') }

      before do
        allow(Nuuvem::Sales).to receive(:create!).with(params).and_raise(error)
        allow(Nuuvem::HandleSaleFileNormalizationWorker).to receive(:perform_async).with(expected_sales_file.path)
        allow(Rails.logger).to receive(:error).with(error.message)
      end

      it 'StandardError is raised and rescued' do
        expect(service).to eq(unsuccessful_response)
        expect(Nuuvem::HandleSaleFileNormalizationWorker).not_to have_received(:perform_async).with(expected_sales_file.path)
        expect(Rails.logger).to have_received(:error).with(error.message)
      end
    end
  end
end
