require 'rails_helper'

RSpec.describe Api::V0::MarketsController, type: :controller do
  describe 'GET #nearest_atms', :vcr do
    let!(:market) { create(:market) }

    context 'when market exists' do
      before do
        get :nearest_atms, params: { id: market.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns ATM data' do
        json_response = JSON.parse(response.body)
        expect(json_response['data']).not_to be_empty
      end
    end
  end
end
