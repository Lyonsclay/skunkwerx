class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @malone_tunes = MaloneTune.all
  end

  def edit
    @malone_tune = MaloneTune.find_by id: params[:id]
  end

  def new
    @malone_tuning = MaloneTuning.find(params[:format])
    @malone_tune = MaloneTune.new
    @malone_tune.name = @malone_tuning.name
    @malone_tune.description = @malone_tuning.description
    @malone_tune.unit_cost ||= price_to_decimal @malone_tuning.unit_cost
    @make_model = make_model_display(@malone_tuning)
  end

  def create
    # Remove malone_tuning which has been created as both
    # tune and option.
    tuning = MaloneTuning.find_by_name malone_tune_params[:name]
    tuning.update_attribute(:tune_created, true)
    if tuning.tune_created && tuning.option_created
      session[:malone_tunings].delete(tuning)
    end
    @malone_tunings = session[:malone_tunings]
    # The user input name needs an extension based on make and model
    # in order to distinquish the tune names such as 'Stage 1'.
    malone_tune_params[:name] += "::" + tuning.make + " " + tuning.model
    MaloneTune.create malone_tune_params
    render "admin/malone_tunings/index"
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
