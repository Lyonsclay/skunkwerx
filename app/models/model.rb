class Model < ActiveRecord::Base
  has_many :engines
  belongs_to :make
end
