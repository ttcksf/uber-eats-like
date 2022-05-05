class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: {greater_than: 0}

  #LineFoodデータの更新とOrderデータの保存処理
  def save_with_update_line_foods!(line_foods)
    #トランザクションの処理
    ActiveRecord::Base.transaction do
      #line_foodsという引数を受け取り、line_foods,eachで一つずつブロック内の処理を実行していく
      line_foods.each do |line_food|
        #update_attributes!とすることで失敗したらsave_with_update_line_foodsも失敗にする
        line_food.update_attributes!(active: false, order: self)
      end
      #save!とすることで失敗したらsave_with_update_line_foodsも失敗にする
      self.save!
    end
  end
end
