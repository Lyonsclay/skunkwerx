require "rails_helper"
require "vehicle_builder"

describe VehicleBuilder do
  before do
    @params = {  build_vehicle: {
                        make: "Makiz",
                        model: "Modelo",
                        engine: "VoomVoom",
                        year: { first: "1980", last: "1999"}
                      } } 
    VehicleBuilder.new(@params)
  end

  describe "#new" do
    it "creates a new Vehicle" do
      count = Vehicle.count
      VehicleBuilder.new(@params)

      expect(Vehicle.count - count).to equal 1
    end

    it "creates a new Make" do
      make = Make.find_by_make @params[:build_vehicle][:make]

      expect(make.valid?).to equal true
    end

    it "creates a new Model" do
      model = Model.find_by_model @params[:build_vehicle][:model]

      expect(model.valid?).to equal true
    end

    it "creates a new Engine" do
      engine = Engine.find_by_engine @params[:build_vehicle][:engine]

      expect(engine.valid?).to equal true
    end

    it "creates a new Year" do
      range = @params[:build_vehicle][:year][:first] + "-" + @params[:build_vehicle][:year][:last]

      year = Year.find_by_range range

      expect(year.valid?).to equal true
    end
  end

  describe "@vehicle" do
    it "returns a vehicle" do
      expect(VehicleBuilder.new(@params).vehicle).to be_a(Vehicle)
    end
  end
end

