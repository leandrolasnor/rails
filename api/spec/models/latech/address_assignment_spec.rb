# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Latech::AddressAssignment do
  it { is_expected.to belong_to(:address) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to delegate_method(:assigned?).to(:make_sure_assignment) }
  it { is_expected.to respond_to(:assigned?) }
end
