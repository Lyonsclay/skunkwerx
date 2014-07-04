class LineItem < ActiveRecord::Base
  belongs_to :product, foreign_key: :item_id, primary_key: :item_id
  belongs_to :malone_tune, foreign_key: :item_id, primary_key: :item_id
  belongs_to :cart

  def total_price
    total = product.unit_cost * quantity if product
    if malone_tune
      if malone_tune.price
        total = malone_tune.price * quantity
      end
    else
      total = 0
    end
    total
  end

  def item
    item = product if product
    item = malone_tune if malone_tune
    item
  end
end
