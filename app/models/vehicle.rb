require 'byebug'

class Vehicle < ActiveRecord::Base
  has_many :malone_tunings
  has_one :make
  has_one :model
  has_one :engine
  belongs_to :year
  
  def set_associations
    self.engine = self.year.engine
    self.model = self.year.engine.model
    self.make = self.year.engine.model.make
  end
  
  def set_name
   self.name = [self.make.make, self.model.model, self.engine.engine, self.year.range].join " "
  end
end
