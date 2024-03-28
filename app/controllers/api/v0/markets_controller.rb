require 'faraday'

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
        market = Market.find_by(id: params[:id])
        result = AtmsFinderService.new.find_nearest_atms(market)

        if result[:errors].present?
            if result[:errors].include?('Market not found')
                status = :not_found
            else
                status = :unprocessable_entity
            end
            render json: { errors: result[:errors] }, status: status
        else
            render json: { data: result[:data] }, status: :ok
        end
    end
end
