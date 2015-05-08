class Year < ActiveRecord::Base
  belongs_to :engine 
  has_one :vehicle
  
  before_save :set_range
  before_save :set_years
  after_create :create_vehicle
  
  def init_vehicle
    self.vehicle.set_associations
    self.vehicle.set_name
    self.vehicle
  end
  
  private

  def set_range
    self.range = years.first.to_s + "-" + years.last.to_s
  end

  def set_years
    self.years = (years.first..years.last).to_a
  end
end 
