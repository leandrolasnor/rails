# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::AddressAssignment, type: :model do
  context 'on Latech' do
    context 'and ::MakeSureAssignment' do
      context 'and ::AddressAssignment' do
        it { expect(described_class.new).to respond_to(:assigned?) }
      end
    end
  end
end
