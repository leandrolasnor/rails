# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nexoos::Financial::Loan, type: :context do
  let(:loan) { described_class.new(create(:loan, pv: pv, nper: nper, rate: rate, user: user)) }
  let(:user) { create(:nexoos_user) }
  let(:pv) { 2300000 }
  let(:nper) { 48 }
  let(:rate) { 150 }
  let(:expected_pmt) { 675.62 }

  describe '.pmt' do
    it { expect(loan.pmt).to eq(expected_pmt) }
  end
end
