class MarketSerializer
    include JSONAPI::Serializer
  
    attributes :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count
end