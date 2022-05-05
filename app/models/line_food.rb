class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: {greater_than: 0}

  #全てのLineFoodからactiveなものを一覧にして返す
  scope :active, ->{where(active: true)}
  #全てのLineFoodからrestaurant_idが特定の店舗IDではないものを一覧にして返す
  #「他の店舗の仮注文があるか？」をチェックするときに使いたい
  scope :other_restaurant, -> (picked_restaurant_id){where.not(restaurant_id: picked_restaurant_id)}

  #仮注文の合計額を求める関数
  def total_amount
    food.price * count
  end
end
