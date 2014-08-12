class MaloneTuning < ActiveRecord::Base
  validates :name, uniqueness: true

end
