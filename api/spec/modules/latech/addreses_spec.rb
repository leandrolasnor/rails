# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Addreses, type: :module do
  describe '.make_sure_assignment' do
    context 'when the address is not assignment' do
      let(:address) { create(:address) }
      let(:user) { create(:latech_user) }
      let(:params) { { address_id: address.id, user_id: user.id } }
      let(:expected_assignment) do
        {
          address_id: address.id,
          user_id: user.id
        }
      end

      it 'must to create a assignment between address and user' do
        described_class.make_sure_assignment(params) do |assignment, errors|
          expect(
            assignment.slice(
              :address_id,
              :user_id
            )
          ).to eq(expected_assignment.stringify_keys)
          expect(errors).to be_nil
        end
      end
    end

    context 'when the address already is assignment' do
      let(:address) { create(:address) }
      let(:params) { { address_id: address.id, user_id: address.users.first.id } }

      it 'must to return nil' do
        described_class.make_sure_assignment(params) do |assignment, errors|
          expect(assignment).to be_nil
          expect(errors).to be_nil
        end
      end
    end

    context 'when to return a message error from ActiveRecord::RecordInvalid' do
      let(:params) { { address_id: nil, user_id: nil } }
      let(:expected_errors) { ['Address must exist', 'User must exist'] }

      it do
        described_class.make_sure_assignment(params) do |_, errors|
          expect(errors.difference(expected_errors)).not_to be_any
        end
      end
    end

    context 'when to return a message error from StandardError' do
      let(:params) { {} }
      let(:expected_errors) { 'key not found: :user_id' }

      it do
        described_class.make_sure_assignment(params) do |_, errors|
          expect(errors).to eq(expected_errors)
        end
      end
    end
  end

  describe '.search' do
    context 'when given valid params' do
      let(:params) do
        {
          query: 'query',
          user_id: 1,
          pagination: {
            limit: 10,
            offset: 0
          }
        }
      end
      let(:params_search) do
        {
          query: params.fetch(:query, ''),
          params: {
            filter: ["user = '#{params.fetch(:user_id)}'"],
            limit: 10,
            offset: 0,
            sort: ['address:asc']
          }
        }
      end

      before do
        allow(Latech::Address).to receive(:search).with(params_search)
      end

      it 'must to call Latech::Address.search correctly' do
        described_class.search(params) do
          expect(Latech::Address).to have_received(:search).with(params_search)
        end
      end
    end

    context 'when StandardError is raise' do
      let(:params) do
        {
          query: 'query',
          pagination: {
            limit: 10,
            offset: 0
          }
        }
      end
      let(:expected_errors) { ['key not found: :user_id'] }

      specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(nil, expected_errors) }
    end
  end

  describe '.capture' do
    let(:user) { create(:latech_user) }
    let(:params) { { zip: '23058500', user_id: user.id } }

    context 'when given valid params' do
      let(:address_created) { user.addreses.first }
      let(:result_cepla) { build(:result_cepla) }

      before do
        allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: params[:zip]).and_return(result_cepla)
      end

      it 'must to create a address by captured address data' do
        described_class.capture(params) do |address_captured|
          expect(address_captured).to eq(address_created)
        end
      end
    end

    context 'when given invalid params' do
      let(:params) { {} }
      let(:expected_errors) { ['key not found: :zip'] }

      it 'must to return a error message from KeyError' do
        described_class.capture(params) do |_, errors|
          expect(errors).to eq(expected_errors)
        end
      end
    end

    context 'when given invalid record data' do
      let(:result_cepla) { build(:result_cepla, logradouro: '') }
      let(:expected_errors) { ["Address can't be blank"] }

      before do
        allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: params[:zip]).and_return(result_cepla)
      end

      it 'must to return a error message from ActiveRecord::RecordInvalid' do
        described_class.capture(params) do |_, errors|
          expect(errors).to eq(expected_errors)
        end
      end
    end

    context 'when receive http error from api external' do
      let(:result_cepla) { build(:result_cepla, logradouro: '') }
      let(:httparty_error) { HTTParty::Error.new }
      let(:expectec_httparty_error) { [I18n.t(:error_on_http_service_from_address_capture)] }

      before do
        allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: params[:zip]).and_raise(httparty_error)
      end

      it 'must to return a error message from HTTParty::Error' do
        described_class.capture(params) do |_, errors|
          expect(errors).to eq(expectec_httparty_error)
        end
      end
    end
  end
end
