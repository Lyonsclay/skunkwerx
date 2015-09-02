class VehicleBuilder

  attr_reader :vehicle

  def self.create(params)
    vehicle_builder = VehicleBuilder.new(params)
    vehicle_builder.vehicle
  end

  def initialize(params)
    @params = params[:build_vehicle]

    @vehicle = Vehicle.new
    @make = Make.find_or_initialize_by(make: @params[:make])
    @model = Model.find_or_initialize_by(model: @params[:model])
    @engine = Engine.new(engine: @params[:engine])
    @year = Year.new(years: set_years)

    build_associations
    
    @vehicle.save
  end

  def build_associations
    @engine.year = @year 
    @model.engines << @engine
    @make.models << @model

    @vehicle.make = @make
    @vehicle.model = @model
    @vehicle.engine = @engine
    @vehicle.year = @year
  end

  def set_years
    first_year = @params[:year][:first]
    last_year = @params[:year][:last]

    (first_year..last_year).to_a
  end
end 
