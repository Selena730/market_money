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
end
