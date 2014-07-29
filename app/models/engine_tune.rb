class EngineTune < ActiveRecord::Base
  belongs_to :malone_tune
  belongs_to :engine
end
