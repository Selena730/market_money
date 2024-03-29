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

    def search
        if search_params_valid?
          markets = Market.search_by(params[:state], params[:city], params[:name])
          render json: MarketSerializer.new(markets).serializable_hash, status: :ok
        else
          error_message = "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
          render json: { errors: [{ detail: error_message }] }, status: :unprocessable_entity
        end
    end
    
    private
      
    def search_params_valid?
        return false if params[:city].present? && params[:state].blank?
        return false if params[:city].present? && params[:name].present? && params[:state].blank?
        true
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
