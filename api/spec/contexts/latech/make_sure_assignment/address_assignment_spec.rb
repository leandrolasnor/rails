# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::MakeSureAssignment::AddressAssignment, type: :context do
  let(:assignment) { build(:address_assignment) }
  let(:assignment_contextualized) { described_class.new(assignment) }
  let(:params) do
    {
      params: {
        filter: [
          "id = '#{assignment.address_id}'",
          "user = '#{assignment.user_id}'"
        ]
      }
    }
  end

  context 'on #assigned?' do
    before do
      allow(Latech::Search::Address).to receive(:search).with(params).and_return({ hits: [true] })
    end

    it do
      expect(assignment_contextualized).to be_assigned
    end
  end
end
