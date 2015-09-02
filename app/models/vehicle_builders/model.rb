class Model < ActiveRecord::Base
  has_many :engines
  belongs_to :make

  validates_uniqueness_of :model, scope: :make_id 
end
