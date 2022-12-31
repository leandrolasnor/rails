# frozen_string_literal: true

module ::Nexoos
  class Loan < ApplicationRecord
    include MeiliSearch::Rails
    meilisearch auto_index: !Rails.env.test?, auto_remove: Rails.env.test?
    meilisearch index_uid: :loan do
      attribute :pv do
        pv / 100
      end
      attribute :rate do
        rate / 100
      end
      attribute :nper
      attribute :user do
        user.email
      end
      displayed_attributes [:pv, :rate, :nper]
      searchable_attributes [:pv, :rate, :nper, :user]
      filterable_attributes [:user]
      sortable_attributes [:pv]
    end

    after_touch :index!

    belongs_to :user, class_name: 'Nexoos::User', touch: true

    delegate :pmt, to: :financial

    validates :rate, numericality: {
      only_integer: true,
      in: 500..1500
    }
    validates :nper, numericality: {
      only_integer: true,
      in: 1..420
    }
    validates :pv, numericality: {
      only_integer: true,
      in: 2000..99999999999
    }

    private

    def financial
      @financial ||= Nexoos::Financial::Loan.new(self)
    end
  end
end
