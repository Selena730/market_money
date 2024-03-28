class AtmsFinderService
  def initialize
    @conn = Faraday.new(url: "https://api.tomtom.com/") do |faraday|
      faraday.params['key'] = Rails.application.credentials.tomtom[:key]
    end
  end

  def find_nearest_atms(market)
    return { errors: ['Market not found'] } if market.nil?

    response = @conn.get("search/2/categorySearch/atm.json", lat: market.lat, lon: market.lon)
    parse_response(response)

  end

  private

  def parse_response(response)
    if response.success?
      data = JSON.parse(response.body, symbolize_names: true)
      atms = data[:results].map do |atm|
        {
          name: atm[:poi][:name],
          address: atm[:address][:freeformAddress],
          distance: atm[:dist]
        }
      end
      if atms.empty?
        { errors: ['No ATMs found'] }
      else
        { data: atms }
      end
    else
      { errors: ['Error retrieving ATMs'] }
    end
  end
end
