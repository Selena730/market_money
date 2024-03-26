class MarketSerializer
    include JSONAPI::Serializer
  
    attributes :name, :street, :city, :county, :state, :zip, :lat, :lon

    attribute :vendor_count do |market|
        market.vendor_count_calc
    end
end