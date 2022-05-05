module Api
  module V1
    class FoodsController < ApplicationController
      def index
        #全てのRestaurantからfindで対応するデータを1つだけ探し出して、その結果をrestaurantに代入
        restaurant = Restaurant.find(params[:restaurant_id])
        #restaurantのリレーション先のfoods一覧をrestaurant.foodsと書くことで取得できるので、それをfoodsに代入
        foods = restaurant.foods
        #json形式で返却してリクエストが成功したらデータと一緒に200を返す
        render json: {
          foods: foods
        }, status: :ok
      end
    end
  end
end
