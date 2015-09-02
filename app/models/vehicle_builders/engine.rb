class Engine < ActiveRecord::Base
  belongs_to :vehicle
  has_one :year
end
