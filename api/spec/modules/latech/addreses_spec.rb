# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Addreses, type: :module do
  describe '#make_sure_assignment' do
    context 'with a new assignment' do
      let(:address) { create(:address) }
      let(:user) { create(:user) }
      let(:params) { { address_id: address.id, user_id: user.id } }
      let(:expected_assignment) { user.address_assignments.first }

      it do
        described_class.make_sure_assignment(params) do |assignment, errors|
          expect(assignment).to eq(expected_assignment)
          expect(errors).to be_nil
        end
      end
    end

    context 'without a new assignment' do
      let(:address) { create(:address) }
      let(:params) { { address_id: address.id, user_id: address.users.first.id } }

      it do
        described_class.make_sure_assignment(params) do |assignment, errors|
          expect(assignment).to be_nil
          expect(errors).to be_nil
        end
      end
    end

    context 'on exception' do
      context 'on ActiveRecord::RecordInvalid' do
        let(:params) { { address_id: nil, user_id: nil } }
        let(:error) { ['Address must exist', 'User must exist'] }

        it do
          described_class.make_sure_assignment(params) do |_, errors|
            expect(errors == error).to be_truthy
          end
        end
      end

      context 'on StandardError' do
        let(:params) { {} }

        specify do
          expect { |b| described_class.make_sure_assignment(params, &b) }.to yield_with_args(nil, 'key not found: :user_id')
        end
      end
    end
  end

  context 'on search' do
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

    context 'on success' do
      before do
        allow(Latech::Search::Address).to receive(:search).with(params_search).and_return(true)
      end

      specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(true) }
    end

    context 'on exception' do
      context 'with StandardError' do
        let(:error) { StandardError.new('Some Error') }

        before do
          allow(Latech::Search::Address).to receive(:search).with(params_search).and_raise(error)
        end

        specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(nil, ['Some Error']) }
      end

      context 'with KeyError' do
        let(:params) do
          {
            query: 'query',
            pagination: {
              limit: 10,
              offset: 0
            }
          }
        end

        specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(nil, ['key not found: :user_id']) }
      end
    end
  end

  context 'on capture' do
    let(:user) { create(:user) }
    let(:params) { { zip: '23058500', user_id: user.id } }

    context 'on success' do
      let(:address_created) { user.addreses.first }
      let(:result_cepla) { build(:result_cepla) }

      before do
        allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: params[:zip]).and_return(result_cepla)
      end

      it do
        described_class.capture(params) do |address_captured|
          expect(address_captured).to eq(address_created)
        end
      end
    end

    context 'on exception' do
      context 'with ActiveRecord::RecordInvalid' do
        let(:result_cepla) { build(:result_cepla, logradouro: '') }

        before do
          allow(Latech::Cepla::Http::Services::GetAddress).to receive(:call!).with(zip: params[:zip]).and_return(result_cepla)
        end

        it do
          expect { |b| described_class.capture(params, &b) }.to yield_with_args(nil, ["Address can't be blank"])
        end
      end

      context 'with StandardError' do
        let(:error) { StandardError.new('Some Error') }

        before do
          allow(Latech::Search::Address).to receive(:create!).and_raise(error)
        end

        it do
          expect { |b| described_class.capture(params, &b) }.to yield_with_args(nil, ['Some Error'])
        end
      end

      context 'with HTTParty::Error' do
        let(:headers) { { accept: 'application/json' } }
        let(:url) { "#{ENV.fetch('LATECH_CEPLA_URI')}/#{params[:zip]}" }
        let(:error) { HTTParty::Error.new('Some Error') }

        before do
          allow(HTTParty).to receive(:get).with(url, headers: headers).and_raise(error)
        end

        it do
          expect { |b| described_class.capture(params, &b) }.to yield_with_args(nil, [I18n.t(:error_on_http_service_from_address_capture)])
        end
      end
    end
  end
end
