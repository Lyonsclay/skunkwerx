class ProductsController < ApplicationController
  def index
    @products = Product.order(:name).page(params[:page]).per(5)
  end

  def edit
  end
end
