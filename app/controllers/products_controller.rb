class ProductsController < ApplicationController
  def index
    if params[:search]
      @products = Product.search(params[:search]).page(params[:page]).per(5)
    else
      @products = Product.order(:name).page(params[:page]).per(5)
    end
  end

  def edit
  end
end
