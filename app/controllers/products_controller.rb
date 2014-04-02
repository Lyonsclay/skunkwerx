require 'pry'

class ProductsController < ApplicationController
  def index
# binding.pry
    @products = Product.order(:name)
  end

  def edit
  end
end
