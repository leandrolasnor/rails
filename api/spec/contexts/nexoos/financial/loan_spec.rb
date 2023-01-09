# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nexoos::Financial::Loan, type: :context do
  subject { loan.pmt }

  let(:loan) do
    create(
      :loan,
      pv: 2300000,
      nper: 48,
      rate: 150,
      user: create(:nexoos_user)
    )
  end

  let(:expected_pmt) { 675.62 }

  describe '.pmt' do
    it { is_expected.to eq expected_pmt }
  end
end
