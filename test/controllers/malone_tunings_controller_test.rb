# require 'test_helper'

# class MaloneTuningsControllerTest < ActionController::TestCase
#   setup do
#     @malone_tuning = malone_tunings(:one)
#   end

#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:malone_tunings)
#   end

#   test "should get new" do
#     get :new
#     assert_response :success
#   end

#   test "should create malone_tuning" do
#     assert_difference('MaloneTuning.count') do
#       post :create, malone_tuning: {  }
#     end

#     assert_redirected_to malone_tuning_path(assigns(:malone_tuning))
#   end

#   test "should show malone_tuning" do
#     get :show, id: @malone_tuning
#     assert_response :success
#   end

#   test "should get edit" do
#     get :edit, id: @malone_tuning
#     assert_response :success
#   end

#   test "should update malone_tuning" do
#     patch :update, id: @malone_tuning, malone_tuning: {  }
#     assert_redirected_to malone_tuning_path(assigns(:malone_tuning))
#   end

#   test "should destroy malone_tuning" do
#     assert_difference('MaloneTuning.count', -1) do
#       delete :destroy, id: @malone_tuning
#     end

#     assert_redirected_to malone_tunings_path
#   end
# end
