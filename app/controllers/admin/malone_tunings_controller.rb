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
    @model_tunes = model_engine_tunes
    @model_tunes.pop if @model_tunes.last[:name].empty?
    @make_model = params[:model][:make]
    @make_model += params[:model][:model] unless params[:model][:model].nil?
    render :index
  end

  def edit
    # Display all params along with ability to create Tune or Option
    # Remove from
  end
end
