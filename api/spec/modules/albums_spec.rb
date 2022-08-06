require 'rails_helper'

RSpec.describe Albums, type: :module do

  context "#show" do
    let(:album) {AlbumSerializer.new(create(:album)).serializable_hash}
    let(:params){{id: album[:id]}}
    let(:params_invalid){{id: 999}}

    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
    end

    it "a album with success" do
      described_class::show(params) do |instance, error|
        expect(instance).to eq(album)
        expect(error).to eq(nil)
      end
    end

    context "raise a error when" do
      let(:record_not_found_error) { ActiveRecord::RecordNotFound.new }

      before do
        allow(Album).to receive(:find).with(999).and_raise(record_not_found_error)
      end

      it "album not found" do
        described_class::show(params_invalid) do |instance, error|
          expect(instance).to eq(nil)
          expect(error).to be_a(Array)
        end
      end
    end

    context "raise a error when" do
      let(:error) { StandardError.new }
  
      before do
        allow(Album).to receive(:find).with(999).and_raise(error)
      end
  
      it "rescue a StandardError" do
        expect {described_class::show(params_invalid) do |instance, error| end}.to raise_error(StandardError)
      end
    end
  end

  context "#create" do
    let(:params){{name: 'Teste', year: 2022, artist_id:1}}
    let(:params_invalid){{name: '', year: 0, artist_id:0}}

    it "a new album with success" do
      described_class::create(params) do |album, error|
        expect(album).to be_a(Album)
        expect(error).to eq(nil)
      end
    end

    context "raise error when" do
      it "fields are invalid" do
        described_class::create(params_invalid) do |instance, error|
          expect(instance).to eq(nil)
          expect(error).to be_a(Array)
        end
      end
    end
    
    context "raise a error when" do
      let(:error) { StandardError.new }
  
      before do
        allow(Albums::Factory).to receive(:make).with(params_invalid).and_raise(error)
      end
  
      it "rescue a StandardError" do
        expect {described_class::create(params_invalid) do |instance, error| end}.to raise_error(StandardError)
      end
    end
  end

  context "#update" do
    let(:album){create(:album)}
    let(:params) {AlbumSerializer.new(album).serializable_hash.merge!(name: 'Teste', artist_id: 1)}
    let(:params_invalid){params.merge!(year: 1500)}

    before do
      allow_any_instance_of(Album).to receive(:artist).and_return({})
    end

    it "a album with success" do
      described_class::update(params) do |album, error|
        expect(album).to be_a(Album)
        expect(album[:name]).to eq('Teste')
        expect(error).to eq(nil)
      end
    end

    context "raise error when" do
      let(:params_invalid_id){params.merge!(id: 999)}

      it "fields are invalids" do
        described_class::update(params_invalid) do |album, error|
          expect(album).to eq(nil)
          expect(error).to be_a(Array)
        end
      end
  
      it "album not found" do
        described_class::update(params_invalid_id) do |instance, error|
          expect(instance).to eq(nil)
          expect(error).to be_a(Array)
          expect(error.first).to eq("Couldn't find Album with 'id'=999")
        end
      end
    end

    context "raise a error when" do
      let(:error) { StandardError.new }
  
      before do
        allow_any_instance_of(Album).to receive(:update!).with(params.slice(:name,:year,:artist_id)).and_raise(error)
      end
  
      it "rescue a StandardError" do
        expect {described_class::update(params) do |instance, error| end}.to raise_error(StandardError)
      end
    end
  end

  context "#search" do
    let(:pagination){{:pages_count=>1, :per_page=>10, :current_page=>1, :items_count=>1}}
    let(:album) { create(:album) }
    let(:params){ {query: "LOWER(name) like '%#{album[:name].downcase!}%'"} }

    it "gets albums" do
      described_class::search(params) do |payload, error|
        expect(payload[:albums]).to be_a(ActiveRecord::Relation)
        expect(payload[:albums].first).to eq(album)
        expect(payload[:albums].count).to eq(1)
        expect(payload[:pagination]).to eq(pagination)
        expect(error).to eq(nil)
      end
    end

    context "return empty array when" do
      let(:params_invalid){ {query: "LOWER(name) like '%XXX%'"} }

      it "params are unenough" do
        described_class::search(params_invalid) do |payload, error|
          expect(payload[:albums]).to be_a(ActiveRecord::Relation)
          expect(payload[:albums]).to eq([])
          expect(error).to eq(nil)
        end
      end
    end
  end

  context "#delete" do
    let(:album) {create(:album)}
    let(:params){{id: album[:id]}}

    before do
      album
    end
    
    it "a album with success" do
      described_class::delete(params) do |instance, error|
        expect(instance).to eq(album)
        expect { Album.find(album[:id]) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(error).to eq(nil)
      end
    end

    context "raise a error when" do
      let(:params_deny_destroy){{id: 9999}}
      let(:params_invalid){{id: 999}}
      let(:record_not_found_error) { ActiveRecord::RecordNotFound.new }
      let(:record_not_destroyed_error) { ActiveRecord::RecordNotDestroyed.new('you cannot destroy', create(:album)) }

      before do
        allow(Albums::Sweeper).to receive(:make).with(params_invalid).and_raise(record_not_found_error)
        allow(Albums::Sweeper).to receive(:make).with(params_deny_destroy).and_raise(record_not_destroyed_error)
      end

      it "album not found" do
        described_class::delete(params_invalid) do |instance, error|
          expect(instance).to eq(nil)
          expect(error).to be_a(Array)
        end
      end

      it "album cannot destroyed" do
        described_class::delete(params_deny_destroy) do |instance, error|
          expect(instance).to eq(nil)
          expect(error).to be_a(Array)
        end
      end
    end

    context "raise a error when" do
      let(:error) { StandardError.new }
  
      before do
        allow(Albums::Sweeper).to receive(:make).with(params).and_raise(error)
      end
  
      it "rescue a StandardError" do
        expect {described_class::delete(params) do |instance, error| end}.to raise_error(StandardError)
      end
    end
  end
end