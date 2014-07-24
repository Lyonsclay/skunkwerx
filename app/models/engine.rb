class Engine < ActiveRecord::Base
  has_many :engine_tunes
  has_many :malone_tunes, through: :engine_tunes
  belongs_to :model
end
