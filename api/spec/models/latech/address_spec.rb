# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Address do
  it { is_expected.to have_many(:address_assignments) }
  it { is_expected.to have_many(:users).through(:address_assignments) }
  it { is_expected.to allow_value(23058500).for(:zip) }
  it { is_expected.not_to allow_value(230500).for(:zip) }
  it { is_expected.not_to allow_value(nil).for(:zip) }
  it { is_expected.not_to allow_value('nil').for(:zip) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:district) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to delegate_method(:capture).to(:cepla) }
  it { is_expected.to respond_to(:capture) }
end
