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

end
