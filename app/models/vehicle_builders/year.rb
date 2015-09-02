class Year < ActiveRecord::Base
  belongs_to :vehicle
  belongs_to :engine

  before_save :set_range

  def set_range
    self.range = years.first.to_s + "-" + years.last.to_s
  end
end
