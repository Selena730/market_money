class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, presence: true
  validates :description, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true

  #https://guides.rubyonrails.org/active_record_validations.html#inclusion
  validates :credit_accepted, inclusion: [true, false]

  def self.find_vendor(id)
    Vendor.find_by(id: id)
  end

  def self.create_vendor(vendor_params)
    Vendor.create(vendor_params)
  end

  def self.destroy_vendor(id)
    vendor = find_vendor(id)
    vendor.destroy if vendor
    vendor
  end

  def self.update_vendor(vendor, vendor_params)
    vendor.update(vendor_params)
  end
end
