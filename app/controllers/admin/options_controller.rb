class Admin::OptionsController < ApplicationController
  layout 'admin/application'

  def new
    @malone_tuning = MaloneTuning.find(params[:format])
    @option = Option.new
    @option.name = @malone_tuning.name
    @option.description = @malone_tuning.description
    @option.unit_cost ||= price_to_decimal @malone_tuning.unit_cost
    @make_model = make_model_display(@malone_tuning)
  end

  def create
    Option.create option_params
    @malone_tunings = session[:malone_tunings]
    render "admin/malone_tunings/tuning_index"
  end

  private

    def option_params
      if params[:option]
        params.require(:option).permit!
      end
    end
end
