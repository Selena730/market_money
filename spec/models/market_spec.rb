require 'rails_helper'

RSpec.describe Market, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe 'associations' do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe '#vendor_count' do
    it 'returns the number of associated vendors' do
      market = create(:market)  
      create_list(:market_vendor, 5, market: market) 

      expect(market.vendor_count).to eq(5)
    end
  end

  describe '.search_by' do
    let!(:market1) { create(:market, name: 'Farmers Market', city: 'Albuquerque', state: 'New Mexico') }
    let!(:market2) { create(:market, name: 'Nob Hill Market', city: 'Albuquerque', state: 'New Mexico') }
    let!(:market3) { create(:market, name: 'Sunday Market', city: 'Denver', state: 'Colorado') }

    it 'returns markets that match the search criteria' do
      results = Market.search_by('New Mexico', 'Albuquerque', nil)

      expect(results).to include(market1, market2)
      expect(results).not_to include(market3)

      results = Market.search_by(nil, nil, 'Farmers')

      expect(results).to include(market1)
      expect(results).not_to include(market2, market3)
    end

    it 'returns an empty array if no markets match the search criteria' do
      results = Market.search_by('New Mexico', 'LA', nil)
      expect(results).to be_empty
    end

    it 'returns all markets if no parameters are given' do
      results = Market.search_by(nil, nil, nil)
      expect(results).to match_array([market1, market2, market3])
    end
  end
end
