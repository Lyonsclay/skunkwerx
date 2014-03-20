require 'test_helper'
require 'pry'

class Admin::ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:product_one)
    @admin = Admin.create(email: "jack@this.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should get index and assign products" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
# binding.pry
    assert_select '.items td.description dt', Product.last.name
    assert_select '.items tr', Product.all.count
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

  test "should get edit and assign image" do
# binding.pry
    sign_in(@admin)
    get :edit, id: @product
    assert_response :success
# binding.pry
    assert_select '.image_url [value=?]', 'Add Photo'
  end

  test "should assign image to product" do
    image = fixture_file_upload 'Doggie.gif'
    patch :update, id: @product, product: { image: image }
    assert_template :index
    assert admin_products_path(assigns(:product))
  end
end
