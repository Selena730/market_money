class Api::V0::VendorsController < ApplicationController

  def show
    vendor = Vendor.find_by(id: params[:id])

    if vendor
      render json: VendorSerializer.new(vendor), status: :ok
    else
      render json: { errors: ['Vendor not found'] }, status: :not_found
    end
  end

  def create
    vendor = Vendor.new(vendor_params)

    if vendor.save
      render json: VendorSerializer.new(vendor), status: :created
    else
      render json: { errors: vendor.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    vendor = Vendor.find_by(id: params[:id])

    if vendor
      vendor.destroy
      # https://api.rubyonrails.org/v7.1.3/classes/ActionController/Head.html
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
