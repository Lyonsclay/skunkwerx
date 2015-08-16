class LineItem < ActiveRecord::Base
  belongs_to :product, foreign_key: :item_id, primary_key: :item_id
  belongs_to :malone_tuning, foreign_key: :item_id, primary_key: :item_id
  belongs_to :cart

  def total_price
    total = product.unit_cost * quantity if product
    if malone_tuning
      if malone_tuning.unit_cost
        total = malone_tuning.unit_cost * quantity
      end
    else
      total = 0
    end
    total
  end

  def item
    item = product if product
    item = malone_tuning if malone_tuning
    item
  end
end
