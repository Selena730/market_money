require 'rails_helper'

RSpec.describe 'MarketVendors API', type: :request do
    describe 'POST /api/v0/market_vendors' do
        it 'Adds a vendor to a market' do
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
            params: { market_id: invalid_market_id, vendor_id: vendor.id }

            expect(response).to have_http_status(:not_found)
            json_response = JSON.parse(response.body, symbolize_names: true)

            expect(json_response[:errors]).to be_a(Array)
            expect(json_response[:errors]).to eq(['Invalid Market ID or Vendor ID'])
        end
    end

    describe 'DELETE /api/v0/market_vendors' do
        let!(:market) { create(:market) }
        let!(:vendor) { create(:vendor) }
        let!(:market_vendor) { create(:market_vendor, market: market, vendor: vendor) }

        it 'deletes the MarketVendor and returns status code 204' do
            headers = { "CONTENT_TYPE" => "application/json" }
            params = { market_id: market.id, vendor_id: vendor.id }.to_json

            expect {
                delete "/api/v0/market_vendors", params: params, headers: headers
            }.to change(MarketVendor, :count).by(-1)

            expect(response).to have_http_status(:no_content)
        end

        it 'returns status code 404 when MarketVendor cannot be found' do
            headers = { "CONTENT_TYPE" => "application/json" }
            params = { market_id: market.id, vendor_id: 0 }.to_json

            delete "/api/v0/market_vendors", params: params, headers: headers

            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)).to eq({"error" => "MarketVendor not found"})


        it 'returns a 422 status and an error message if market_vendor already exists' do
            market = create(:market)
            vendor = create(:vendor)

            create(:market_vendor, market: market, vendor: vendor)

            body = JSON.generate({ market_id: market.id, vendor_id: vendor.id })
            headers = { 'CONTENT_TYPE' => 'application/json' }

            post '/api/v0/market_vendors', params: body, headers: headers

            expect(response).to have_http_status(:unprocessable_entity)

            json_response = JSON.parse(response.body, symbolize_names: true)
            expect(json_response[:errors]).to be_a(Array)
        end
    end
end
