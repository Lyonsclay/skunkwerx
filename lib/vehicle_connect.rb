class VehicleConnect
  def initialize(params)
    @params = params
    get_vehicle
    delete_vehicles
  end

  def get_vehicle
    build_vehicle if @params[:build_vehicle][:make].present?
    select_vehicle if @params[:select_vehicle][:make].present?
  end

  def select_vehicle
    @vehicle = VehicleSelector.find(@params)
  end

  def build_vehicle
    @vehicle = VehicleBuilder.create(@params)
  end

  def associate(tune)
    @vehicle.malone_tunes << tune
    @vehicle.malone_tunes.include? tune
  end
  
  def delete_vehicles
    # params[:engine_tunes_delete] used in admin/malone/tunes/edit.html.erb
  end
end 
