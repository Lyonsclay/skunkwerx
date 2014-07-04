class Order < ActiveRecord::Base
  PAYMENT_TYPES = ["Check", "Paypal"]
  has_many :line_items, dependent: :destroy
end
