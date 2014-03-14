class ProductsController < ApplicationController
  def index
    @products = Product.order(:name)
  end

  def edit
  end
end
