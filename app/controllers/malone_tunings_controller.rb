class MaloneTuningsController < ApplicationController

  def index_deploy
    @malone_tunings = MaloneTuning.all
  end
end
