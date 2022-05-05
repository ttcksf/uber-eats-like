class CreateLineFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :line_foods do |t|
      #外部キーであるfood_idというカラムがline_foodテーブルに生成される。
      t.references :food, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      #orderはnullを許可しておく
      t.references :order, foreign_key: true
      t.integer :count, null: false, default: 0
      t.boolean :active, null: false, default: false

      t.timestamps
    end
  end
end
