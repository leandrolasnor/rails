# frozen_string_literal: true

module ::Latech
  class Address < ApplicationRecord
    include MeiliSearch::Rails
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :address do
      attribute :address
      attribute :district
      attribute :city
      attribute :state
      attribute :zip
      attribute :user do
        address_assignments.pluck(:user_id)
      end
      displayed_attributes [:id, :address, :district, :city, :state, :zip]
      searchable_attributes [:address, :district, :city, :state, :zip]
      filterable_attributes [:id, :zip, :user]
      sortable_attributes [:address]
    end

    after_touch :index!

    has_many :address_assignments, inverse_of: :address, dependent: :destroy
    has_many :users, through: :address_assignments

    delegate :capture, to: :cepla

    validates :address, presence: true
    validates :district, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zip, format: { with: /([0-9])\d{7}/ }

    default_scope { order(address: :asc) }

    private

    def cepla
      @cepla ||= Latech::Cepla::Address.new(self)
    end
  end
end
