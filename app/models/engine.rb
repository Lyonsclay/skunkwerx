class Engine < ActiveRecord::Base
  belongs_to :model
  belongs_to :malone_tune
end
