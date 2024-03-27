class Api::V0::VendorsController < ApplicationController

  def show
    vendor = VendorFacade.find_vendor(params[:id])

    if vendor
      render_vendor(vendor, status = :ok)
    else
      render_vendor_not_found
    end
  end

  def create
    vendor = VendorFacade.create_vendor(vendor_params)

    if vendor.save
      render_vendor(vendor, status = :created)
    else
      render_errors(vendor)
    end
  end

  def update
    vendor = VendorFacade.find_vendor(params[:id])

    if vendor
      VendorFacade.update_vendor(vendor, vendor_params)
      if vendor.valid?
        render_vendor(vendor, status = :ok)
      else
        render_errors(vendor)
      end
    else
      render_vendor_not_found
    end
  end

  def destroy
    vendor = VendorFacade.destroy_vendor(params[:id])

    if vendor
      head :no_content
    else
      render_vendor_not_found
    end
  end

  private

  def render_vendor_not_found
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
end
