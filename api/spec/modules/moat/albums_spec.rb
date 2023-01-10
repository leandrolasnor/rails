# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Albums, type: :module do
  describe '.show' do
    let(:album) { create(:album) }

    context 'when params are correct' do
      let(:params) { { id: album[:id] } }
      let(:serializable) { Moat::AlbumSerializer.new(album).serializable_hash }

      it 'must to get serialized album object' do
        described_class.show(params) do |instance, error|
          expect(instance).to eq(serializable)
          expect(error).to be_nil
        end
      end
    end

    context 'when params are not correct' do
      let(:params) { { id: 999 } }
      let(:expected_error) { ["Couldn't find Moat::Album with 'id'=999"] }

      it 'must to get a array of errors' do
        described_class.show(params) do |instance, error|
          expect(instance).to be_nil
          expect(error).to eq(expected_error)
        end
      end
    end
  end

  describe '.create' do
    context 'when params is correct' do
      let(:params) { { name: 'Teste', year: 2022, artist_id: 1 } }

      it 'must to create a album object' do
        described_class.create(params) do |album, error|
          expect(
            album.slice(
              :name,
              :year,
              :artist_id
            ).symbolize_keys
          ).to eq(params)
          expect(error).to be_nil
        end
      end
    end

    context 'when params is not correct' do
      let(:params) { { name: nil, year: 0, artist_id: 0 } }
      let(:expected_error) do
        [
          "Name can't be blank",
          'Year must be greater than or equal to 1948'
        ]
      end

      it 'must to get a array of errors' do
        described_class.create(params) do |album, error|
          expect(album).to be_nil
          expect(error).to eq(expected_error)
        end
      end
    end
  end

  describe '.update' do
    let(:album) { create(:album, name: 'Some album', year: 1950, artist_id: 5) }

    context 'when params is correct' do
      let(:params) { { id: album.id, name: 'Teste', year: 2022, artist_id: 1 } }

      it 'must to create a album object' do
        described_class.update(params) do |album, error|
          expect(
            album.slice(
              :id,
              :name,
              :year,
              :artist_id
            ).symbolize_keys
          ).to eq(params)
          expect(error).to be_nil
        end
      end
    end

    context 'when params is not correct' do
      let(:params) { { id: album.id, name: nil, year: 0 } }
      let(:expected_error) do
        [
          "Name can't be blank",
          'Year must be greater than or equal to 1948'
        ]
      end

      it 'must to get a array of errors' do
        described_class.update(params) do |album, error|
          expect(album).to be_nil
          expect(error).to eq(expected_error)
        end
      end
    end
  end

  describe '.search' do
    let(:params) do
      {
        query: 'query',
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
          limit: 10,
          offset: 0,
          sort: ['name:asc']
        }
      }
    end

    context 'on success' do
      before do
        allow(Moat::Album).
          to receive(:search).
          with(params_search).
          and_return(true)
      end

      it do
        expect { |b| described_class.search(params, &b) }.
          to yield_with_args(true, nil)
      end
    end

    context 'on exception' do
      context 'with StandardError' do
        let(:error) { StandardError.new('Some Error') }

        before do
          allow(Moat::Album).
            to receive(:search).
            with(params_search).
            and_raise(error)
        end

        it do
          expect { |b| described_class.search(params, &b) }.
            to yield_with_args(nil, ['Some Error'])
        end
      end
    end
  end

  describe '.delete' do
    let(:album) { create(:album) }
    let(:params) { { id: album[:id] } }

    before do
      album
    end

    it 'a album with success' do
      described_class.delete(params) do |instance, error|
        expect(instance).to eq(album)
        expect(
          Moat::Album.find(album[:id])
        ).to raise_error(ActiveRecord::RecordNotFound)
        expect(error).to be_nil
      end
    end

    context 'when raise a [::RecordNotFound, ::RecordNotDestroyed]' do
      let(:params_deny_destroy) { { id: 9999 } }
      let(:params_invalid) { { id: 999 } }
      let(:record_not_found_error) { ActiveRecord::RecordNotFound.new }
      let(:record_not_destroyed_error) do
        ActiveRecord::RecordNotDestroyed.new(
          'you cannot destroy',
          create(:album)
        )
      end

      before do
        allow(Moat::Albums::Sweeper).
          to receive(:make).
          with(params_invalid).
          and_raise(record_not_found_error)
        allow(Moat::Albums::Sweeper).
          to receive(:make).
          with(params_deny_destroy).
          and_raise(record_not_destroyed_error)
      end

      it 'album not found' do
        described_class.delete(params_invalid) do |instance, error|
          expect(instance).to be_nil
          expect(error).to be_a(Array)
        end
      end

      it 'album cannot destroyed' do
        described_class.delete(params_deny_destroy) do |instance, error|
          expect(instance).to be_nil
          expect(error).to be_a(Array)
        end
      end
    end

    context 'when raise a StandardError' do
      let(:error) { StandardError.new }

      before do
        allow(
          Moat::Albums::Sweeper
        ).to receive(:make).with(params).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.delete(params) }.to raise_error(StandardError)
      end
    end
  end
end
