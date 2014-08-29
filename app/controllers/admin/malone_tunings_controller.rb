# This controller scrapes malonetuning.com gathering
# attributes of tunes in preparationfor creating a
# MaloneTune or Option.
class Admin::MaloneTuningsController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  # List of engines from malonetuning.com.
  # User selects engine to show associated tunes.
  def vehicle_index
    @models = vehicle_models
  end

  # List of tunings for particular engine.
  # Buttons for create tune or option.
  def index
    @malone_tunings = session[:malone_tunings]
  end

  # Show all tunes for selected engine.
  # User selects tunes to create as Product and MaloneTune.
  # Post '/create'
  def create
    @malone_tunings = vehicle_tunings
    @malone_tunings.pop if @malone_tunings.last[:name].empty?
    @make_model = make_model_display(@malone_tunings.first)
    render :index
  end
end