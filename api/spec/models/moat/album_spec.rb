# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Moat::Album do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:artist_id) }
  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_numericality_of(:year).is_greater_than_or_equal_to(1948).only_integer }
  it { is_expected.to delegate_method(:artist).to(:moat) }
  it { is_expected.to respond_to(:artist) }
end
