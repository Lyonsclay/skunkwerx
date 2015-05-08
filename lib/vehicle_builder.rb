require 'byebug'

class VehicleBuilder

  attr_reader :vehicle
  
  def initialize(params)
    @years = params[:build_vehicle][:year]
    @params = params[:build_vehicle].except(:year)
    @year = set_year
    
    build_associations
    @vehicle = set_vehicle
  end

  def create(params)
    VehicleBuilder.new(params).vehicle
  end
  
  def build_associations
    Engine.create(engine: @params[:engine]).years << @year
    Model.create(model: @params[:model]).engines << @year.engine
    Make.create(make: @params[:make]).models << @year.engine.model
  end

  def set_year
   years = (@years[:start]..@years[:finish]).to_a
   Year.create(years: years)
  end

  def set_vehicle
    @year.init_vehicle
  end
end 
