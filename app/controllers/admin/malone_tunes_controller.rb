class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @malone_tunes = MaloneTune.all
  end

  def edit
    @malone_tune = MaloneTune.find params[:id]
  end

  def new
    @malone_tuning = MaloneTuning.find params[:id]
    @malone_tune = MaloneTune.new
    @malone_tune.name = @malone_tuning.name
    @malone_tune.description = @malone_tuning.description
    @malone_tune.unit_cost = price_to_decimal @malone_tuning.unit_cost || @malone_tune.unit_cost
    @make_model = make_model_display(@malone_tuning)
  end

  def create
    tune = MaloneTune.create malone_tune_params
    VehicleConnect.new(params).associate(tune)
    @malone_tunings = session[:malone_tunings]
    render "admin/malone_tunings/tuning_index"
  end

  def update
    params[:malone_tune][:image] = nil if params["default_image"] == "1"
    malone_tune = MaloneTune.find_by id: params[:id]
    malone_tune.update(malone_tune_params)
    vehicle = Vehicle.find_by id: params[:select_vehicle][:vehicle]
   
    create_and_add_new_engine(malone_tune)
    delete_engine_tunes(malone_tune)
    redirect_to '/admin/malone_tunes'
  end

  private

    def malone_tune_params
      if params[:malone_tune]
        params.require(:malone_tune).permit!
      end
    end
end
