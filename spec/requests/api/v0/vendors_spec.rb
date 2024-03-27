require 'rails_helper'

RSpec.describe 'Api::V0::Vendors', type: :request do
  describe 'GET /api/v0/vendors/:id' do
    let!(:vendor) { create(:vendor) }

    context 'when the vendor exists' do
      before { get "/api/v0/vendors/#{vendor.id}" }

      it 'returns the vendor' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the vendor does not exist' do
      before { get '/api/v0/vendors/999' }

      it 'returns a not found error' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v0/vendors' do
    let(:valid_attributes) { attributes_for(:vendor) }

    context 'with valid parameters' do
      it 'creates a new vendor' do
        expect {
          post '/api/v0/vendors', params: { vendor: valid_attributes }
        }.to change(Vendor, :count).by(1)
      end

      it 'returns the created vendor' do
        post '/api/v0/vendors', params: { vendor: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          description: '',
          contact_name: '',
          contact_phone: '',
          credit_accepted: true
        }
      end

      let(:invalid_credit_accepted) do
        {
          name: 'Test',
          description: 'Testy test',
          contact_name: 'Dr. Testy Test Jr. III Esq.',
          contact_phone: '999-999-9999',
          credit_accepted: nil
        }
      end

      it 'returns a bad request status and error message' do
        post '/api/v0/vendors', params: { vendor: invalid_attributes }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['errors']).to be_present
      end

      it 'returns a bad request status if "credit_accepted" value is nil' do
        post '/api/v0/vendors', params: { vendor: invalid_credit_accepted }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'DELETE /api/v0/vendors/:id' do
    context 'with a valid id' do
      let!(:vendor) { create(:vendor) }

      it 'deletes the vendor' do
        expect {
          delete "/api/v0/vendors/#{vendor.id}"
        }.to change(Vendor, :count).by(-1)
      end

      it 'returns a 204 status code' do
        delete "/api/v0/vendors/#{vendor.id}"
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with an invalid id' do
      it 'returns a 404 status code and error message' do
        delete '/api/v0/vendors/999'
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include('errors')
        expect(JSON.parse(response.body)['errors']).to include('Vendor not found')
      end
    end
  end

  describe "GET /api/v0/markets/:market_id/vendors" do
    it "returns all vendors for the market with a status of 200" do #happy path
      market = create(:market)
      vendors = create_list(:vendor, 2)
      vendors.each do |vendor|
        MarketVendor.create(market: market, vendor: vendor)
      end
    
      get "/api/v0/markets/#{market.id}/vendors"
    
      expect(response).to have_http_status(200) # Checks for HTTP 200 status
    
      json_response = JSON.parse(response.body)
      expect(json_response['data'].length).to eq(2) 
      vendor_attributes = json_response['data'].first['attributes']
      expect(vendor_attributes).to include(
        'name',
        'description',
        'contact_name',
        'contact_phone',
        'credit_accepted'
      )
    end

    
    it "returns a 404 status and an error message for an invalid market id" do
      invalid_id = 123123123123
    
      get "/api/v0/markets/#{invalid_id}/vendors"
    
      expect(response).to have_http_status(404)
      expect(response).to_not be_successful
    
      json_response = JSON.parse(response.body, symbolize_names: true)
    
      expect(json_response[:errors]).to be_a(Array)
      expect(json_response[:errors].first).to include(
        detail: "Couldn't find Market with 'id'=#{invalid_id}"
      )
    end
  end
end
