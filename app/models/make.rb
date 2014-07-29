class Make < ActiveRecord::Base
  has_many :models, -> { uniq }
end
