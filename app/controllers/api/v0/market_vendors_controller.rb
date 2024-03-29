class Api::V0::MarketVendorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create

        if params[:market_id].blank? || params[:vendor_id].blank?
            render json: { errors: ["Market ID and Vendor ID must be provided"] }, status: :bad_request
            return
        end
        market = Market.find_by(id: params[:market_id])
        vendor = Vendor.find_by(id: params[:vendor_id])

        if market.nil? || vendor.nil?
            render json: { errors: ["Invalid Market ID or Vendor ID"] }, status: :not_found
            return
        end
        market_vendor = MarketVendor.new(market: market, vendor: vendor)

        if market_vendor.save
            render json: { message: "Added vendor to market" }, status: :created
        else
            render json: { errors: market_vendor.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        body_parameters = request.request_parameters
        market_id = body_parameters['market_id']
        vendor_id = body_parameters['vendor_id']

        if market_id.blank? || vendor_id.blank?
            render json: { errors: ["Market ID and Vendor ID must be provided"] }, status: :bad_request
            return
        end

        market_vendor = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)

        if market_vendor
            market_vendor.destroy
            head :no_content
        else
            render json: { error: 'MarketVendor not found' }, status: :not_found
        end
    end

    private

    def record_not_found(error)
        render json: { errors: [error.message] }, status: :not_found
    end
end
