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

  def self.update_vendor(vendor, vendor_params)
    vendor.update(vendor_params)
  end
end
