# This controller scrapes malonetuning.com gathering
# attributes of tunes in preparationfor creating a
# MaloneTune or Option.
class Admin::MaloneTuningsController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  # List of engines from malonetuning.com.
  # User selects engine to show associated tunes.
  # Get '/show'
  def vehicle_index
    @models = vehicle_models
  end

  def index

  end

  # Show all tunes for selected engine.
  # User selects tunes to create as Product and MaloneTune.
  # Post '/create'
  def create
    @malone_tunings = vehicle_tunings
    @malone_tunings.pop if @malone_tunings.last[:name].empty?
    @make_model = params[:model][:make]
    @make_model += params[:model][:model] unless params[:model][:model].nil?
    render :index
  end

  def edit
    # Display all params along with ability to create Tune or Option
    # Remove from
  end
end
