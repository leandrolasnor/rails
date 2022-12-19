# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Albums, type: :module do
  context 'on show' do
    let(:album) { Moat::AlbumSerializer.new(create(:album)).serializable_hash }
    let(:params) { { id: album[:id] } }
    let(:params_invalid) { { id: 999 } }

    before do
      allow_any_instance_of(Moat::Search::Album).to receive(:artist).and_return({})
    end

    it 'a album with success' do
      described_class.show(params) do |instance, error|
        expect(instance).to eq(album)
        expect(error).to be_nil
      end
    end

    context 'when raise a ActiveRecord::RecordNotFound' do
      let(:record_not_found_error) { ActiveRecord::RecordNotFound.new }

      before do
        allow(Moat::Search::Album).to receive(:find).with(999).and_raise(record_not_found_error)
      end

      it 'album not found' do
        described_class.show(params_invalid) do |instance, error|
          expect(instance).to be_nil
          expect(error).to be_a(Array)
        end
      end
    end

    context 'when raise a StandardError' do
      let(:error) { StandardError.new }

      before do
        allow(Moat::Search::Album).to receive(:find).with(999).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.show(params_invalid) }.to raise_error(StandardError)
      end
    end
  end

  context 'on create' do
    let(:params) { { name: 'Teste', year: 2022, artist_id: 1 } }
    let(:params_invalid) { { name: '', year: 0, artist_id: 0 } }

    it 'a new album with success' do
      described_class.create(params) do |album, error|
        expect(album).to be_a(Moat::Search::Album)
        expect(error).to be_nil
      end
    end

    context 'when create raise error' do
      it 'fields are invalid' do
        described_class.create(params_invalid) do |instance, error|
          expect(instance).to be_nil
          expect(error).to be_a(Array)
        end
      end
    end

    context 'when create raise a StandardError' do
      let(:error) { StandardError.new }

      before do
        allow(Moat::Albums::Factory).to receive(:make).with(params_invalid).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.create(params_invalid) }.to raise_error(StandardError)
      end
    end
  end

  context 'on update' do
    let(:album) { create(:album) }
    let(:params) { Moat::AlbumSerializer.new(album).serializable_hash.merge!(name: 'Teste', artist_id: 1) }
    let(:params_invalid) { params.merge!(year: 1500) }

    before do
      allow_any_instance_of(Moat::Search::Album).to receive(:artist).and_return({})
    end

    it 'a album with success' do
      described_class.update(params) do |album, error|
        expect(album).to be_a(Moat::Search::Album)
        expect(album[:name]).to eq('Teste')
        expect(error).to be_nil
      end
    end

    context 'when update raise error' do
      let(:params_invalid_id) { params.merge!(id: 999) }

      it 'fields are invalids' do
        described_class.update(params_invalid) do |album, error|
          expect(album).to be_nil
          expect(error).to be_a(Array)
        end
      end

      it 'album not found' do
        described_class.update(params_invalid_id) do |instance, error|
          expect(instance).to be_nil
          expect(error).to be_a(Array)
          expect(error.first).to eq("Couldn't find Moat::Search::Album with 'id'=999")
        end
      end
    end

    context 'when raise a StandardError' do
      let(:error) { StandardError.new }

      before do
        allow_any_instance_of(Moat::Search::Album).to receive(:update!).with(params.slice(:name, :year, :artist_id)).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.update(params) }.to raise_error(StandardError)
      end
    end
  end

  context 'on search' do
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
        allow(Moat::Search::Album).to receive(:search).with(params_search).and_return(true)
      end

      specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(true, nil) }
    end

    context 'on exception' do
      context 'with StandardError' do
        let(:error) { StandardError.new('Some Error') }

        before do
          allow(Moat::Search::Album).to receive(:search).with(params_search).and_raise(error)
        end

        specify { expect { |b| described_class.search(params, &b) }.to yield_with_args(nil, ['Some Error']) }
      end
    end
  end

  context 'on delete' do
    let(:album) { create(:album) }
    let(:params) { { id: album[:id] } }

    before do
      album
    end

    it 'a album with success' do
      described_class.delete(params) do |instance, error|
        expect(instance).to eq(album)
        expect { Moat::Search::Album.find(album[:id]) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(error).to be_nil
      end
    end

    context 'when raise a [ActiveRecord::RecordNotFound, ActiveRecord::RecordNotDestroyed]' do
      let(:params_deny_destroy) { { id: 9999 } }
      let(:params_invalid) { { id: 999 } }
      let(:record_not_found_error) { ActiveRecord::RecordNotFound.new }
      let(:record_not_destroyed_error) { ActiveRecord::RecordNotDestroyed.new('you cannot destroy', create(:album)) }

      before do
        allow(Moat::Albums::Sweeper).to receive(:make).with(params_invalid).and_raise(record_not_found_error)
        allow(Moat::Albums::Sweeper).to receive(:make).with(params_deny_destroy).and_raise(record_not_destroyed_error)
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
        allow(Moat::Albums::Sweeper).to receive(:make).with(params).and_raise(error)
      end

      it 'rescue a StandardError' do
        expect { described_class.delete(params) }.to raise_error(StandardError)
      end
    end
  end
end
