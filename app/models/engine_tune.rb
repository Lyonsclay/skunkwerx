class EngineTune < ActiveRecord::Base
  belongs_to :malone_tune
  belongs_to :engine

  #Nicely formatted make/model/string
  def vehicle
    self.engine.model.make.make + " " +
      self.engine.model.model + " " +
      self.engine.engine + " " +
      self.engine.years.first + "-" +
      self.engine.years.last
  end
end
