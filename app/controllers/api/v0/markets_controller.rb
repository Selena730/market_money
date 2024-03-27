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
end