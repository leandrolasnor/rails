# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::MakeSureAssignment::AddressAssignment, type: :context do
  describe '#assigned?' do
    let(:assignment) do
      address_assignment = build(:address_assignment)
      address = create(:address)
      user = create(:user)
      address_assignment.address_id = address.id
      address_assignment.user_id = user.id
      address_assignment.save!
      address_assignment
    end
    let(:assignment_contextualized) { described_class.new(assignment) }

    specify { expect(assignment_contextualized).to be_assigned }
  end
end
