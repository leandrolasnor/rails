# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Republic::Line::Awesome do
  describe 'when prepended by CanOfPaint' do
    let(:klass) { Republic::CanOfPaint.class.prepend(described_class) }
    let(:expected_kinds) { [18, 3.6, 2.5, 0.5] }
    let(:expected_ink_liter_yield) { 5 }

    it 'must be able CanOfPaint::KINDS as a contant' do
      expect(klass::KINDS).to eq(expected_kinds)
    end

    it 'must be able CanOfPaint::INK_LITER_YIELD as a contant' do
      expect(klass::INK_LITER_YIELD).to eq(expected_ink_liter_yield)
    end
  end
end
