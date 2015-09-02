class Admin::MaloneTuningsController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @malone_tunings = MaloneTuning.all
  end

  def edit
    @malone_tuning = MaloneTuning.find params[:id]
  end

  def new
    @malone_tuning_builder = MaloneTuningBuilder.find params[:id]
    @malone_tuning = MaloneTuning.new
    @malone_tuning.name = @malone_tuning_builder.name
    @malone_tuning.description = @malone_tuning_builder.description
    @malone_tuning.unit_cost = price_to_decimal @malone_tuning_builder.unit_cost || @malone_tuning.unit_cost
    @make_model = make_model_display(@malone_tuning_builder)
  end

  def create
    tune = MaloneTuning.create malone_tuning_params
    VehicleConnect.new(params).associate(tune)
    @malone_tuning_builders = session[:malone_tuning_builders]
    render "admin/malone_tuning_builders/tunings_index"
  end

  def update
    params[:malone_tuning][:image] = nil if params["default_image"] == "1"
    malone_tuning = MaloneTuning.find_by id: params[:id]
    malone_tuning.update(malone_tuning_params)
    vehicle = Vehicle.find_by id: params[:select_vehicle][:vehicle]
   
    create_and_add_new_engine(malone_tuning)
    delete_engine_tunes(malone_tuning)
    redirect_to '/admin/malone_tunings'
  end

  private

    def malone_tuning_params
      if params[:malone_tuning]
        params.require(:malone_tuning).permit!
      end
    end
end
