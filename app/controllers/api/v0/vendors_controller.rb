class Api::V0::VendorsController < ApplicationController

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

  def update
    vendor = VendorFacade.find_vendor(params[:id])

    if vendor
      if vendor.update(vendor_params)
        render json: VendorSerializer.new(vendor), status: :ok
      else
        render json: { errors: vendor.errors.full_messages }, status: :bad_request
      end
    else
      render json: { errors: ['Vendor not found'] }, status: :not_found
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

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end
