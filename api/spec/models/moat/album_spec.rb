# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Album do
  subject(:album) { create(:album, artist_id: 5) }

  it 'must have validate_presence_of' do
    expect(album).to validate_presence_of(:name)
    expect(album).to validate_presence_of(:artist_id)
    expect(album).to validate_presence_of(:year)
  end

  it 'must have validate_numericality_of' do
    expect(subject).to validate_numericality_of(:year).is_greater_than_or_equal_to(1948).only_integer
  end

  context 'on Moat' do
    context 'and ::Api' do
      context 'and ::Album' do
        it { expect(album).to respond_to(:artist) }
      end
    end
  end
end
