class Admin::ProductsController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    session[:sync_discrepancy] = ""
    @products = Product.all
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    product = Product.find(params[:id])
    product.update(product_params)
    @products = Product.order(:name)
    render :index
  end

  private

  def product_params
    if params[:product]
      params.require(:product).permit(:image)
    end
  end
end
