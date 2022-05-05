module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        #Redtaurantモデルを使ってrestaurantsに全ての情報を代入
        restaurants = Restaurant.all
        #json形式で返却して、リクエストが成功したら200をデータと一緒に返すようにする
        render json: {
          restaurants: restaurants
        }, status: :ok
      end
    end
  end
end
