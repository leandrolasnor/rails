# frozen_string_literal: true

module ::Latech
  class AddressAssignment < ApplicationRecord
    belongs_to :address, class_name: 'Latech::Address'
    belongs_to :user, class_name: 'Latech::User'

    delegate :assigned?, to: :make_sure_assignment

    private

    def make_sure_assignment
      @make_sure_assignment ||= Latech::MakeSureAssignment::AddressAssignment.new(self)
    end
  end
end
