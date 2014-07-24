class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def malone_tuning_index
    @models = vehicle_models
  end

  def index
    @malone_tunes = MaloneTune.all
  end

  def show
    @model_tunes = model_engine_tunes
    @model_tunes.pop if @model_tunes.last[:name].empty?
    @make_model = params[:model][:make]
    @make_model += params[:model][:model] unless params[:model][:model].nil?
  end

  def create
    @tune_ids = new_malone_tunes_from_params
  end

  def edit
    @malone_tune = MaloneTune.find_by id: params[:id]
  end

  def update
    params[:malone_tune][:image] = nil if params["default_image"] == "1"
    malone_tune = MaloneTune.find_by id: params[:id]
    malone_tune.update(malone_tune_params)
    unless params[:add_from_list][:engine].empty?
      engine = Engine.find_by_sql(["SELECT * FROM engines WHERE engine=? AND model_id IN (SELECT models.id FROM models WHERE id=?)", params[:add_from_list][:engine], params[:add_from_list][:model][:id]]).first
      malone_tune.engines << engine
    end
    vehicle = params[:add_vehicle]
    unless vehicle[:make].empty?
      make = Make.find_or_create_by(make: vehicle[:make])
      model = make.models.find_or_create_by(model: vehicle[:model])
      engine = model.engines.find_or_create_by(engine: vehicle[:engine])
      engine.years += (vehicle[:years][:start].to_i..vehicle[:years][:end].to_i).to_a
      engine.years.uniq!
      engine.save
      malone_tune.engines << engine
    end
    if params[:engine_delete]
      params[:engine_delete].each { |id| Engine.find(id.to_i).delete }
    end
    redirect_to '/admin/malone_tunes'
  end

   private

    def malone_tune_params
      if params[:malone_tune]
        params.require(:malone_tune).permit!
      end
    end
end