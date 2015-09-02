class Make < ActiveRecord::Base
  has_many :models
  belongs_to :vehicle
end
