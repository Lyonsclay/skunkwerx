require 'pry'

class Admin::ProductsController < ApplicationController
  layout 'admin'

  def index
    @products = Product.order(:name)
  end

  def edit
# binding.pry
    @product = Product.find(params[:id])
  end

  def update
# binding.pry
    product = Product.find(params[:id])
    product.update(product_params)
    @products = Product.order(:name)
    render '/admin/products/index'
  end

  private

  def product_params
    if params[:product]
      params.require(:product).permit(:image)
    end
  end

end
