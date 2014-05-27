require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    product = products(:product_one)
    @line_item = LineItem.create(product_id: product.id)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:product_one).id
    end
    assert_redirected_to cart_path(assigns(:line_item).cart)
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      xhr :post, :create, product_id: products(:product_one).id
    end

    assert_response :success
    assert_select_jquery :html, '.side' do
      assert_select 'tr td', /#{products(:product_one).name}/
    end
  end

  test "should show line_item" do
    get :show, id: @line_item, line_item_ids: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    patch :update, id: @line_item, line_item: { product_id: @line_item.product_id }, line_item_ids: @line_item
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item, line_item_ids: @line_item
    end
    assert_redirected_to line_items_path
  end
end