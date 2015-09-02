include MaloneTuningsScraper
# This controller scrapes malonetuning.com gathering
# attributes of tunings in preparationfor creating a
# MaloneTuning or Option.
class Admin::MaloneTuningBuildersController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  # List of engines from malonetuning.com.
  # User selects engine to show associated tunings.
  def vehicle_index
    @models = vehicle_models
    # session[:vehicle_models] = @models
  end
  
  # List of tunings for particular engine.
  # Buttons for create tune or option.
  def tunings_index
    @malone_tuning_builders = vehicle_tunings
    session[:malone_tuning_builders] = @malone_tuning_builders 
  end

  ## Show all tunings for selected engine.
  ## User selects tunes to create as Product and MaloneTuning.
  ## Post '/create'
  # def create
  #   @malone_tuning_builders = vehicle_tunings
  #   @malone_tuning_builders.pop if @malone_tuning_builders.last[:name].empty?
  #   @make_model = make_model_display(@malone_tuning_builders.first)
  #   render :tuning_index
  # end
end
