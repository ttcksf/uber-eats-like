class Restaurant < ApplicationRecord
  has_many :foods
  has_many :line_foods, through: :foods

  #nameとfeeが必ず存在（presence :true）
  validates :name, :fee, :time_required, presence: true
  #nameが最大30文字以下
  validates :name, length: {maximum: 30}
  #feeが０以上になる
  validates :fee, numericality: {greater_than: 0}

end
