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
end
