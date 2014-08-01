class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  # List of engines from malonetuning.com.
  # User selects engine to show associated tunes.
  # Get '/show'
  def malone_tuning_index
    @models = vehicle_models
  end

  # Presently '/malone_tunes/index_deploy'
  def index
    @malone_tunes = MaloneTune.all
  end

  # Show all tunes for selected engine.
  # User selects tunes to create as Product and MaloneTune.
  # Post '/create'
  def show
    @model_tunes = model_engine_tunes
    @model_tunes.pop if @model_tunes.last[:name].empty?
    @make_model = params[:model][:make]
    @make_model += params[:model][:model] unless params[:model][:model].nil?
  end

  #
  def create
binding.pry
    # @tune_ids = new_malone_tunes_from_params
  end

  def edit
    @malone_tune = MaloneTune.find_by id: params[:id]
  end

  def update
    params[:malone_tune][:image] = nil if params["default_image"] == "1"
    malone_tune = MaloneTune.find_by id: params[:id]
    malone_tune.update(malone_tune_params)
    add_engine_from_list(malone_tune)
    create_and_add_new_engine(malone_tune)
    delete_engines(malone_tune)
    redirect_to '/admin/malone_tunes'
  end

  private

    def malone_tune_params
      if params[:malone_tune]
        params.require(:malone_tune).permit!
      end
    end
end