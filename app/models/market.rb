class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lon, presence: true

  def vendor_count 
    vendors.count
  end

  def self.search_by(state, city, name)
    query = Market.all

    query = query.where("state ILIKE ?", "%#{state}%") if state.present?
    query = query.where("city ILIKE ?", "%#{city}%") if city.present?
    query = query.where("name ILIKE ?", "%#{name}%") if name.present?

    query
  end
end
