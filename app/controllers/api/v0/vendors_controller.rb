class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    vendor = VendorFacade.find_vendor(params[:id])

    if vendor
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render json: { errors: ['Vendor not found'] }, status: :not_found
    end
  end

  def create
    vendor = VendorFacade.create_vendor(vendor_params)

    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    vendor = VendorFacade.destroy_vendor(params[:id])

    if vendor
      head :no_content
    else
      render json: { errors: ['Vendor not found'] }, status: :not_found
    end
  end

  def index
    # binding.pry
    market = Market.find(params[:market_id])

    if market
      vendors = market.vendors
      render json: VendorSerializer.new(vendors), status: :ok
    else 
      render json: {errors: [{ detail: "Market with 'id'=#{params[:market_id]} not found"}]}, status: :not_found
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def record_not_found(exception)
    render json: { errors: [{ detail: exception.message }] }, status: :not_found
  end
end
