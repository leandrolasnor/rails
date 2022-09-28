# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::Address, type: :model do
  subject(:address) { create(:address) }

  context 'validations' do
    it 'must have validate_presence_of' do
      expect(address).to validate_presence_of(:address)
      expect(address).to validate_presence_of(:district)
      expect(address).to validate_presence_of(:city)
      expect(address).to validate_presence_of(:state)
    end

    context 'with zip field matched format /([0-9])\d{7}/' do
      it { is_expected.to allow_value(23058500).for(:zip) }
      it { is_expected.not_to allow_value(230500).for(:zip) }
      it { is_expected.not_to allow_value(nil).for(:zip) }
      it { is_expected.not_to allow_value('nil').for(:zip) }
    end
  end

  context 'on Latech' do
    context 'and ::Cepla' do
      context 'and ::Address' do
        it { expect(address).to respond_to(:capture) }
      end
    end
  end
end
