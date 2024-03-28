require 'rails_helper'

RSpec.describe "Api::V0::MarketsController", type: :request do
  describe 'GET #nearest_atms', :vcr do
    let!(:market) { create(:market, lat: "38.6270", lon: "90.1994") }

    it 'returns a list of nearest ATMs' do
      get "/api/v0/markets/#{market.id}/nearest_atms"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']).not_to be_empty
    end

    it 'returns a 404 when the market is not found' do
      get "/api/v0/markets/4654657/nearest_atms"

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['errors']).to include('Market not found')
    end
  end
end
