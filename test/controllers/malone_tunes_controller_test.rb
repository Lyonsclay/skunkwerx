require 'test_helper'

class MaloneTunesControllerTest < ActionController::TestCase
  setup do
    @malone_tune = malone_tunes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:malone_tunes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create malone_tune" do
    assert_difference('MaloneTune.count') do
      post :create, malone_tune: {  }
    end

    assert_redirected_to malone_tune_path(assigns(:malone_tune))
  end

  test "should show malone_tune" do
    get :show, id: @malone_tune
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @malone_tune
    assert_response :success
  end

  test "should update malone_tune" do
    patch :update, id: @malone_tune, malone_tune: {  }
    assert_redirected_to malone_tune_path(assigns(:malone_tune))
  end

  test "should destroy malone_tune" do
    assert_difference('MaloneTune.count', -1) do
      delete :destroy, id: @malone_tune
    end

    assert_redirected_to malone_tunes_path
  end
end
