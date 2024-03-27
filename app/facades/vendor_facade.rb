class VendorFacade
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
end
