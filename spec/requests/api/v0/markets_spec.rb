require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  it "returns all markets" do
    markets = create_list(:market, 3)
    markets.each { |market| create_list(:market_vendor, 2, market: market) }
    get '/api/v0/markets'

    expect(response).to have_http_status(200)
    json_response = JSON.parse(response.body)
    expect(json_response['data'].count).to eq(3)
  end

  it "returns markets with correct attributes including vendor_count" do
    markets = create_list(:market, 3)
    markets.each { |market| create_list(:market_vendor, 2, market: market) }
    get '/api/v0/markets'

    json_response = JSON.parse(response.body)
    expect(json_response['data'].first['attributes']).to include(
      'name',
      'street',
      'city',
      'county',
      'state',
      'zip',
      'lat',
      'lon',
      'vendor_count'
    )
  end

  describe "GET /api/v0/markets/:id" do
    it "returns the market and a status of 200" do #happy path test
      market = create(:market)
      create_list(:market_vendor, 2, market: market)
      get "/api/v0/markets/#{market.id}"

      expect(response).to have_http_status(200)
      json_response = JSON.parse(response.body)
      expect(json_response['data']['attributes']).to include(
      'name' => market.name,
      'street' => market.street,
      'city' => market.city,
      'county' => market.county,
      'state' => market.state,
      'zip' => market.zip,
      'lat' => market.lat.to_s,
      'lon' => market.lon.to_s,
      'vendor_count' => 2
      )
    end

    it "returns a 404 status and an error message" do # sad path test
      invalid_id = 123123123123
      get "/api/v0/markets/#{invalid_id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=#{invalid_id}")
    end
  end

  describe 'GET /api/v0/markets/search' do
    let!(:market1) { create(:market, name: 'Farmers Market', city: 'Albuquerque', state: 'New Mexico') }
    let!(:market2) { create(:market, name: 'Nob Hill Market', city: 'Albuquerque', state: 'New Mexico') }
    let!(:market3) { create(:market, name: 'Sunday Market', city: 'Denver', state: 'Colorado') }

    it 'returns markets in the specified state' do
      get '/api/v0/markets/search', params: { state: 'New Mexico' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      
      expect(json_response['data'].size).to eq(2)
    end

    it 'returns markets in the specified state and city' do
      get '/api/v0/markets/search', params: { state: 'New Mexico', city: 'Albuquerque' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['data'].size).to eq(2)
    end

    it 'returns markets matching all criteria' do
      get '/api/v0/markets/search', params: { state: 'New Mexico', city: 'Albuquerque', name: 'Nob Hill' }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['data'].size).to eq(1)
      expect(json_response['data'][0]['attributes']['name']).to eq('Nob Hill Market')
    end

    it 'returns an error for invalid parameter' do
      get '/api/v0/markets/search', params: { city: 'Albuquerque' }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)

      expect(json_response['errors']).to be_present
      expect(json_response['errors'][0]['detail']).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
    end
  end
end
