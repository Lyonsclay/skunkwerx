class Admin::OptionsController < ApplicationController
  layout 'admin/application'

  def new
    @malone_tuning_builder = MaloneTuningBuilder.find(params[:format])
    @option = Option.new
    @option.name = @malone_tuning_builder.name
    @option.description = @malone_tuning_builder.description
    @option.unit_cost ||= price_to_decimal @malone_tuning_builder.unit_cost
    @make_model = make_model_display(@malone_tuning_builder)
  end

  def create
    Option.create option_params
    @malone_tuning_builders = session[:malone_tuning_builders]
    render "admin/malone_tuning_builders/tuning_index"
  end

  private

    def option_params
      if params[:option]
        params.require(:option).permit!
      end
    end
end
