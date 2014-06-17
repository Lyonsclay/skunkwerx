class MaloneTunesController < ApplicationController

  def index_deploy
    @malone_tunes = MaloneTune.all
  end
end
