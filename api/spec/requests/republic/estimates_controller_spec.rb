# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Republic::EstimatesController do
  let(:headers_credentials) do
    sign_in_response = sign_in
    {
      uid: sign_in_response.dig(:headers, 'uid'),
      client: sign_in_response.dig(:headers, 'client'),
      'access-token': sign_in_response.dig(:headers, 'access-token')
    }
  end

  describe '#quantity_of_can_of_paint' do
    context 'with correct params' do
      let(:params) do
        {
          halls: [
            {
              walls: [
                {
                  height: 3,
                  width: 4.2,
                  doors_count: 1,
                  windows_count: 0
                },
                {
                  height: 3,
                  width: 4.8,
                  doors_count: 0,
                  windows_count: 1
                }
              ]
            },
            {
              walls: [
                {
                  height: 3.2,
                  width: 6,
                  doors_count: 2,
                  windows_count: 1
                },
                {
                  height: 3.2,
                  width: 6,
                  doors_count: 0,
                  windows_count: 2
                }
              ]
            }
          ]
        }
      end
      let(:expected_body) do
        {
          code: 0,
          message: 'ok',
          payload: [
            { cop: 18.0, quantity: 0 },
            { cop: 3.6, quantity: 2 },
            { cop: 2.5, quantity: 1 },
            { cop: 0.5, quantity: 2 }
          ]
        }
      end

      before do
        post(republic_estimates_quantity_of_can_of_paint_path, params: params, headers: headers_credentials, as: :json)
      end

      it 'must receive quantity of can of paint' do
        expect(response).to have_http_status(:ok)
        expect(json_body).to eq(expected_body)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          halls: [
            {
              walls: [
                {
                  height: 3,
                  width: 0,
                  doors_count: 0,
                  windows_count: 0
                }
              ]
            },
            {
              walls: [
                {
                  height: 3,
                  width: 4.2,
                  doors_count: 5,
                  windows_count: 10
                },
                {
                  height: 3,
                  width: 4.8,
                  doors_count: 0,
                  windows_count: 1
                },
                {
                  height: 3.756,
                  width: 4.8,
                  doors_count: 0,
                  windows_count: 1
                },
                {
                  height: 0,
                  width: 4.888,
                  doors_count: -1,
                  windows_count: 1
                },
                {
                  height: 3,
                  width: 0,
                  doors_count: 0,
                  windows_count: -1
                },
                {
                  height: 2,
                  width: 2,
                  doors_count: 1,
                  windows_count: 0
                }
              ]
            }
          ]
        }
      end
      let(:expected_body) do
        {
          code: -1,
          message: [
            'Width must be greater than 0',
            'Walls must have area between 1 and 50 square meters',
            'The total area of the doors and windows must be a maximum of 50% of the wall area',
            'Height field is badly formatted',
            'Height must be greater than 0',
            'Width field is badly formatted',
            'Doors count must be greater than or equal to 0',
            'Walls must have area between 1 and 50 square meters',
            'Width must be greater than 0',
            'Windows count must be greater than or equal to 0',
            'Walls must have area between 1 and 50 square meters',
            'The height of walls with a door must be at least 30 centimeters higher than the height of the door',
            'The quantity of walls inside a hall must be a value between one e four'
          ]
        }
      end

      before do
        post(republic_estimates_quantity_of_can_of_paint_path, params: params, headers: headers_credentials, as: :json)
      end

      it 'must receive a errors messages' do
        expect(response).to have_http_status(:bad_request)
        expect(json_body).to eq(expected_body)
      end
    end

    context 'when a key error happens' do
      let(:params) { nil }
      let(:expected_body) do
        {
          code: -1,
          message: 'key not found: "halls"'
        }
      end

      before do
        post(republic_estimates_quantity_of_can_of_paint_path, params: params, headers: headers_credentials, as: :json)
      end

      it 'must receive a error response' do
        expect(response).to have_http_status(:bad_request)
        expect(json_body).to eq(expected_body)
      end
    end
  end
end
