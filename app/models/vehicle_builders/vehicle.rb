require 'byebug'

class Vehicle < ActiveRecord::Base
  has_many :malone_tunings
  has_one :make
  has_one :model
  has_one :engine
  has_one :year
  
  def set_name
   self.name = [self.make.make, self.model.model, self.engine.engine, self.year.range].join " "
  end
end
