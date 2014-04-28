require 'pry'

class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'

  def index
    unless current_admin
      redirect_to root_path
    end
    @models = vehicle_models
  end

  def show
    @model_tunes = model_engine_tunes
    @stock_engine = @model_tunes.first[:engine]
    @stock_power = @model_tunes.first[:power]
    @model_tunes.shift
    @make_model = params[:model][:make] + params[:model][:model]
  end

  def create
  end
end