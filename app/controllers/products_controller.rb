require 'pry'

class ProductsController < ApplicationController
  layout 'admin', only: :admin_products
  def index
# binding.pry
    @products = Product.order(:name)
  end

  def admin_products
# binding.pry
    @products = Product.order(:name)
  end

  def edit
  end
end
