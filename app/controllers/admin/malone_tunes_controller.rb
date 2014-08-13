class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @malone_tunes = MaloneTune.all
  end

  def create
    # The user input name needs an extension based on make and model
    # in order to distinquish the tune names such as 'Stage 1'.
    malone_tune_params[:name] += params[:make_model]
    malone_tune = MaloneTune.create malone_tune_params
    # Remove malone_tuning which has been created as tune and/or option.
    session[:malone_tunings].delete(MaloneTuning.find_by_name(malone_tune[:name]))
    @malone_tunings = session[:malone_tunings]
    render "admin/malone_tunings/index"
  end

  def edit
    @malone_tune = MaloneTune.find_by id: params[:id]
  end

  def new
    @malone_tuning = MaloneTuning.find(params[:format])
    @malone_tune = MaloneTune.new
    @malone_tune.name = @malone_tuning.name
    @malone_tune.description = @malone_tuning.description
    @malone_tune.unit_cost = price_to_decimal @malone_tuning.unit_cost
    @malone_tune.save
    # Make and model will be passed as hidden params to be
    # added to the malone_tune.name. This method is necessary
    # because text_field uses malone_tune[:name], and not
    # malone_tune.name which has been redefined in the malone_tune.rb.
    @make_name = @malone_tuning.make
    @model_name = @malone_tuning.model
  end

    # The user input name needs an extension based on make and model
    # in order to distinquish the tune names such as 'Stage 1'.
    malone_tune_params[:name] += "::" + tuning.make + " " + tuning.model
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