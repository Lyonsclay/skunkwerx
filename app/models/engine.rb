class Engine < ActiveRecord::Base
  belongs_to :model
  belongs_to :vehicle
  has_many :years
end
