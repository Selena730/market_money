class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    vendor = Vendor.find_vendor(params[:id])

    if vendor
      render_vendor(vendor, status = :ok)
    else
      render_not_found
    end
  end

  def create
    vendor = Vendor.create_vendor(vendor_params)

    if vendor.save
      render_vendor(vendor, status = :created)
    else
      render_errors(vendor)
    end
  end

  def update
    vendor = Vendor.find_vendor(params[:id])

    if vendor
      Vendor.update_vendor(vendor, vendor_params)
      if vendor.valid?
        render_vendor(vendor, status = :ok)
      else
        render_errors(vendor)
      end
    else
      render_not_found
    end
  end

  def destroy
    vendor = Vendor.destroy_vendor(params[:id])

    if vendor
      head :no_content
    else
      render_not_found
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

  def render_not_found
    render json: { errors: ['Vendor not found'] }, status: :not_found
  end

  def render_vendor(vendor, status = :ok)
    render json: VendorSerializer.new(vendor), status: status
  end

  def render_errors(vendor)
    render json: { errors: vendor.errors.full_messages }, status: :bad_request
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def record_not_found(exception)
    render json: { errors: [{ detail: exception.message }] }, status: :not_found
  end
end
