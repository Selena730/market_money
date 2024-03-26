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

  describe '#vendor_count_calc' do
    it 'returns the number of associated vendors' do
      market = create(:market)  
      create_list(:market_vendor, 5, market: market) 

      expect(market.vendor_count_calc).to eq(5)
    end
  end
end
