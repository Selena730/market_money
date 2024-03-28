require 'rails_helper'

RSpec.describe 'POST /api/v0/market_vendors', type: :request do
    describe 'Create market vendors' do
        it 'Adds a vendor to a market' do # happy path
            market = create(:market)
            vendor = create(:vendor)

            post '/api/v0/market_vendors', 
            params: { market_id: market.id, vendor_id: vendor.id }

            expect(response).to have_http_status(:created)

            json_response = JSON.parse(response.body, symbolize_names: true)
            expect(json_response[:message]).to eq('Added vendor to market')
        end

        it 'returns a 404 status and an error message' do
            market = create(:market)
            vendor = create(:vendor)
            invalid_market_id = 98752743673

            post '/api/v0/market_vendors', 
            params: { invalid_market_id: market.id, vendor_id: vendor.id }
        
            expect(response).to have_http_status(:not_found)
            json_response = JSON.parse(response.body, symbolize_names: true)
        
            expect(json_response[:errors]).to be_a(Array)
            expect(json_response[:errors]).to eq('Invalid Market ID or Vendor ID')
        end
    end
end
