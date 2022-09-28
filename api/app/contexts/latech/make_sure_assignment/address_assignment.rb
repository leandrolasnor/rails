# frozen_string_literal: true

module ::Latech
  module MakeSureAssignment
    class AddressAssignment
      attr_reader :assignment

      def initialize(assignment)
        @assignment = assignment
      end

      def assigned?
        @assigned ||= Latech::Search::Address.search(params: params)[:hits].present?
      end

      private

      def params
        {
          filter: [
            "id = '#{assignment.address_id}'",
            "user = '#{assignment.user_id}'"
          ]
        }
      end
    end
  end
end
