class Api::V0::MarketsController < ApplicationController
    def index
        markets = Market.all
        render json: MarketSerializer.new(markets).serializable_hash
    end
end