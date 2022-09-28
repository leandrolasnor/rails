# frozen_string_literal: true

class Latech::AddresesController < ApiController
  def search
    authorize!(:read, Latech::Address)
    deliver(Latech::SearchAddresesService.call(address_search_params))
  end

  def capture
    authorize!(:read, Latech::Address)
    authorize!(:create, Latech::Address)
    deliver(Latech::CaptureAddressService.call(address_capture_params))
  end

  private

  def address_params
    params.fetch(:address, {}).merge(search_pagination_params).merge(channel_params)
  end

  def address_search_params
    address_params.merge(
      user_id: current_user.id,
      query: params.fetch(:query, '')
    ).permit(
      :query,
      :user_id,
      :channel, {
        pagination: [
          :limit,
          :offset
        ]
      }
    )
  end

  def address_capture_params
    address_params.merge(
      user_id: current_user.id,
      zip: params.fetch(:zip)
    ).permit(:zip, :user_id, :channel)
  end
end
