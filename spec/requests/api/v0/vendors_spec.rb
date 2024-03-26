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
          credit_accepted: nil
        }
      end

      it 'returns a bad request status and error message' do
        post '/api/v0/vendors', params: { vendor: invalid_attributes }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
