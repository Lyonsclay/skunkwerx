require 'pry'

class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @models = vehicle_models
  end

  def show
    @model_tunes = model_engine_tunes
    @model_tunes.pop if @model_tunes.last[:name].empty?
    @make_model = params[:model][:make]
    @make_model += params[:model][:model] unless params[:model][:model].nil?
  end

  def create
  end
end