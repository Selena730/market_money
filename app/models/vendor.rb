class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true

  #https://guides.rubyonrails.org/active_record_validations.html#inclusion
  validates :credit_accepted, inclusion: [true, false]
end
