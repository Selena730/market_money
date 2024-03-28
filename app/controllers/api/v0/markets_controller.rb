requiire 'faraday'

class Api::V0::MarketsController < ApplicationController
    def index
        markets = Market.all
        render json: MarketSerializer.new(markets).serializable_hash
    end

    def show
        market = Market.find_by(id: params[:id])

        if market
            render json: MarketSerializer.new(market), status: :ok
        else
            render json: {errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
        end
    end

    def nearest_atms
        #find the market

        #if the market is not found, return a 404

        #this will be in a service:
        #make a request to tomtom
        #https://developer.tomtom.com/search-api/documentation/search-service/category-search

        #parse the response
        #if successful - render the data with a status of ok
        #else - render an unprocessable_entity error
    end
end
