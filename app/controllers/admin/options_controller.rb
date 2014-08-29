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
    # Remove malone_tuning which has been created as tune and option.
    tuning = MaloneTuning.find_by_name option_params[:name]
    tuning.update_attribute(:tune_created, true)
    if tuning.tune_created && tuning.option_created
      session[:malone_tunings].delete(tuning)
    end
    @malone_tunings = session[:malone_tunings]
    # The user input name needs an extension based on make and model
    # in order to distinquish the tune names such as 'Stage 1'.
    option_params[:name] += "::" + tuning.make + " " + tuning.model
    Option.create option_params
    render "admin/malone_tunings/index"
  end

  private

    def option_params
      if params[:option]
        params.require(:option).permit!
      end
    end
end
