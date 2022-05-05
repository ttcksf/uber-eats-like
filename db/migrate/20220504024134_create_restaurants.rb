class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    #restaurantsというテーブルを作る
    create_table :restaurants do |t|
      #string型のnameというカラムを作成して、オプションとしてnullができないようにする
      t.string :name, null: false
      #string型のnameというカラムを作成して、デフォルトで0が入るようにする
      t.integer :fee, null: false, default: 0
      t.integer :time_required, null: false

      t.timestamps
    end
  end
end
