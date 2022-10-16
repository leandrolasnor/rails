# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nuuvem::SalesController, type: :request do
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe 'POST #upload' do
    context 'with tab file in params' do
      let(:file) { fixture_file_upload('files/example_input.tab', 'text/xml') }
      let(:sales_upload_params) do
        ActionController::Parameters.new(
          {
            file: file,
            channel: headers_credentials[:client]
          }
        ).permit(:file, :channel)
      end

      before do
        allow(Nuuvem::UploadSalesService).to receive(:call).with(sales_upload_params)
        post(nuuvem_sales_upload_path, params: { file: file }, headers: headers_credentials, as: :json)
      end

      it 'renders a successful response' do
        expect(response.body).to eq successful_body_content
        expect(Nuuvem::SearchSalesService).to have_received(:call).with(sales_search_params)
        expect(response).to be_successful
      end
    end

    context 'without tab file in params' do
      let(:error) { ActionController::ParameterMissing.new('params missing') }

      before do
        allow(Nuuvem::UploadSalesService).to receive(:call)
        allow(Rails.logger).to receive(:error).with(error.message)
        post(nuuvem_sales_upload_path, headers: headers_credentials, as: :json)
      end

      it 'renders a unsuccessful response' do
        expect(response.body).to be_nil
        expect(response).to have_http_status(:bad_request)
        expect(Rails.logger).to have_received(:error).with(error.message)
        expect(Nuuvem::SearchSalesService).not_to have_received(:call)
      end
    end
  end

  describe 'GET #search' do
    context 'with query param' do
      let(:sale_search_params) do
        ActionController::Parameters.new({
          query: 'query',
          channel: headers_credentials[:client],
          pagination: ActionController::Parameters.new({
            limit: 10,
            offset: 0
          })
        }).permit(
          :query,
          :channel, {
            pagination: [
              :limit,
              :offset
            ]
          }
        )
      end

      before do
        allow(Nuuvem::SearchSalesService).to receive(:call).with(sale_search_params).and_return(successful_response)
        get(nuuvem_sales_search_path(query: 'query'), headers: headers_credentials, as: :json)
      end

      it 'renders a successful response' do
        expect(response.body).to eq successful_body_content
        expect(Nuuvem::SearchSalesService).to have_received(:call).with(sales_search_params)
        expect(response).to be_successful
      end
    end

    context 'without query param' do
      let(:sale_search_params) do
        ActionController::Parameters.new({
          query: '',
          channel: headers_credentials[:client],
          pagination: ActionController::Parameters.new({
            limit: 10,
            offset: 0
          })
        }).permit(
          :query,
          :channel, {
            pagination: [
              :limit,
              :offset
            ]
          }
        )
      end

      before do
        allow(Nuuvem::SearchSalesService).to receive(:call).with(sale_search_params).and_return(successful_response)
        get(nuuvem_sales_search_path, headers: headers_credentials, as: :json)
      end

      it 'renders a successful response' do
        expect(response.body).to eq successful_body_content
        expect(Nuuvem::SearchSalesService).to have_received(:call).with(sale_search_params)
        expect(response).to be_successful
      end
    end
  end
end
