class Admin::MaloneTunesController < ApplicationController
  layout 'admin/application'
  before_filter :authorize

  def index
    @malone_tunes = MaloneTune.all
  end

  def create
    MaloneTune.create malone_tune_params

  end

  def edit
    @malone_tune = MaloneTune.find_by id: params[:id]
  end

  def new
    @malone_tuning = MaloneTuning.find(params[:format])
    @malone_tune = MaloneTune.new
    @malone_tune.name = @malone_tuning.name
    @malone_tune.description = @malone_tuning.description
    @malone_tune.unit_cost = @malone_tuning.unit_cost
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