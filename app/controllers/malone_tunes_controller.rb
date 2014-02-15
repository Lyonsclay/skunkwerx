class MaloneTunesController < ApplicationController
  before_action :set_malone_tune, only: [:show, :edit, :update, :destroy]

  # GET /malone_tunes
  # GET /malone_tunes.json
  def index
    @malone_tunes = MaloneTune.all
  end

  # GET /malone_tunes/1
  # GET /malone_tunes/1.json
  def show
  end

  # GET /malone_tunes/new
  def new
    @malone_tune = MaloneTune.new
  end

  # GET /malone_tunes/1/edit
  def edit
  end

  # POST /malone_tunes
  # POST /malone_tunes.json
  def create
    @malone_tune = MaloneTune.new(malone_tune_params)

    respond_to do |format|
      if @malone_tune.save
        format.html { redirect_to @malone_tune, notice: 'Malone tune was successfully created.' }
        format.json { render action: 'show', status: :created, location: @malone_tune }
      else
        format.html { render action: 'new' }
        format.json { render json: @malone_tune.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /malone_tunes/1
  # PATCH/PUT /malone_tunes/1.json
  def update
    respond_to do |format|
      if @malone_tune.update(malone_tune_params)
        format.html { redirect_to @malone_tune, notice: 'Malone tune was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @malone_tune.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /malone_tunes/1
  # DELETE /malone_tunes/1.json
  def destroy
    @malone_tune.destroy
    respond_to do |format|
      format.html { redirect_to malone_tunes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_malone_tune
      @malone_tune = MaloneTune.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def malone_tune_params
      params[:malone_tune]
    end
end
