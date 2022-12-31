# frozen_string_literal: true

module ::Nexoos
  class LoansController < ApiController
    def search
      authorize!(:read, Nexoos::Loan)
      deliver(Nexoos::SearchLoansService.call(loan_search_params))
    end

    def show
      authorize!(read: Nexoos::Loan)
      deliver(Nexoos::ShowLoanService.call(show_loan_params))
    end

    def create
      authorize!(create: Nexoos::Loan)
      deliver(Nexoos::CreateLoanService.call(loan_create_params))
    end

    private

    def loan_params
      params.fetch(:loan, {}).merge(
        channel_params,
        user: current_user
      )
    end

    def show_loan_params
      loan_params.permit!(
        :id,
        :channel,
        :user
      )
    end

    def create_loan_params
      loan_params.merge(
        rate: loan_params.fetch(:rate).to_s.delete('.,').to_i,
        pv: loan_params.fetch(:pv).to_s.delete('.,').to_i
      ).permit!(
        :rate,
        :nper,
        :pv,
        :user
      )
    end

    def loan_search_params
      loan_params.merge(
        search_pagination_params
      ).merge(
        query: loan_params.fetch(:query, '')
      ).permit!(
        :query,
        :channel,
        {
          pagination: [
            :limit,
            :offset
          ]
        }
      )
    end
  end
end
