# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Republic::CanOfPaint, type: :module do
  subject { described_class.for_paint(area) }

  describe '#for_paint' do
    context 'when param area is 66.24' do
      let(:area) { 66.24 }
      let(:expected) do
        [
          { cop: 18, quantity: 0 },
          { cop: 3.6, quantity: 3 },
          { cop: 2.5, quantity: 1 },
          { cop: 0.5, quantity: 0 }
        ]
      end

      it 'must return all objects with correct quantity' do
        expect(subject).to eq(expected)
      end
    end

    context 'when param area is 1' do
      let(:area) { 1 }
      let(:expected) do
        [
          { cop: 18, quantity: 0 },
          { cop: 3.6, quantity: 0 },
          { cop: 2.5, quantity: 0 },
          { cop: 0.5, quantity: 1 }
        ]
      end

      it 'must return just the last object with quantity one' do
        expect(subject).to eq(expected)
      end
    end

    context 'when param area is zero' do
      let(:area) { 0 }
      let(:expected) do
        [
          { cop: 18, quantity: 0 },
          { cop: 3.6, quantity: 0 },
          { cop: 2.5, quantity: 0 },
          { cop: 0.5, quantity: 0 }
        ]
      end

      it 'must return all objects with quantity zero' do
        expect(subject).to eq(expected)
      end
    end

    context 'when param area is negative number' do
      let(:area) { -10.8 }
      let(:expected) do
        [
          { cop: 18, quantity: 0 },
          { cop: 3.6, quantity: 0 },
          { cop: 2.5, quantity: 0 },
          { cop: 0.5, quantity: 0 }
        ]
      end

      it 'must return all objects with quantity zero' do
        expect(subject).to eq(expected)
      end
    end
  end

  describe 'constants' do
    context 'when prepend Line::Awesome' do
      it 'must be able CanOfPaint::KINDS as contant' do
        expect(described_class::KINDS).to eq([18, 3.6, 2.5, 0.5])
      end

      it 'must be able CanOfPaint::INK_LITER_YIELD as contant' do
        expect(described_class::INK_LITER_YIELD).to eq(5)
      end
    end
  end
end
