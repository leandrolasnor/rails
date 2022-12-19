# frozen_string_literal: true

module ::Latech
  module MakeSureAssignment
    class AddressAssignment
      attr_reader :assignment

      def initialize(assignment)
        @assignment = assignment
      end

      def assigned?
        @assigned ||= ApplicationRecord.reader do
          Latech::AddressAssignment.exists?(address_id: assignment.address_id, user_id: assignment.user_id)
        end
      end
    end
  end
end
