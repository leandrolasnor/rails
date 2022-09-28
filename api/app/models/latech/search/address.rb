# frozen_string_literal: true

module ::Latech
  module Search
    class Address < Latech::Address
      include MeiliSearch::Rails

      after_touch :index!

      meilisearch index_uid: :latech_search_address do
        attribute :address
        attribute :district
        attribute :city
        attribute :state
        attribute :zip
        attribute :user do
          address_assignments.pluck(:user_id)
        end
        displayed_attributes [:address, :district, :city, :state, :zip]
        searchable_attributes [:address, :district, :city, :state, :zip]
        filterable_attributes [:id, :zip, :user]
        sortable_attributes [:address]
      end

      def self.search(query: '', params: {})
        Meilisearch::Index.latech_search_address do |index|
          index.search(query, params).symbolize_keys!
        end
      end
    end
  end
end
