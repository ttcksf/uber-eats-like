module Api
  module V1
    class LineFoodsController < ApplicationController
      #create、replaceメソッドの前にset_food関数を呼ぶ
      before_action :set_food, only: %i[create replace]

      def index
        #LineFoodモデルの中からactiveなものを取得して、line?foodsという変数に代入（line_food.rbより）
        line_foods = LineFood.active
        #line_foodsが空かどうかを判断。対象のインスタンスがDBに存在するかどうか
        if line_foods.exists?
          render json: {
            #line_foodsというインスタンスそれぞれをline_foodという変数名で、line_food.idとして各idを取得して、配列名line_food_idsとして作る
            line_food_ids: line_foods.map{|line_food| line_food.id},
            #１つの仮注文につき1つの店舗なので、line_foodsの中にある先頭のline_foodインスタンスの店舗情報を入れる（line_foods.first.restaurantとも同様）
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum{|line_food| line_food[:count]},
            #total_amount関数で合計金額を求める（line_food.rbより）
            amount: line_foods.sum{|line_food| line_food.total_amount},
          }, status: :ok
        else
          #activeなLineFoodが1つも存在しない時は空データと２０４を返す
          render json: {}, status: :no_content
        end
      end

      def create
        #「他店舗でactiveなLineFood」をActiveRecord_Relationの形で取得して、存在するかをexistsで判断する
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          #存在する場合はJSON形式でデータを返却。existing_restaurantで既に作成されている他店舗の情報と、new_restaurantで作成しようとしている新店舗の情報を返す。ステータスコードは４０６（not acceptable）にする
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable
        end
        #「他店舗でactiveなLineFood」が存在しない場合は、set_line_food関数を実行
        set_line_food(@ordered_food)

        #@line_foodをDBに保存する
        if @line_food.save
          #保存できた時は保存したデータを返す
          render json: {
            line_food: @line_food
          }, status: :created
        #エラーが発生した場合はエラーを返す
        else
          render json: {}, status: :internal_server_error
        end
      end

      def replace
        #他店舗のLineFoodを一つずつ取り出してupdate_attributeで更新していく。更新内容は引数に渡された(:active, false)でline_food.activeをfalseにする
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
          line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        #↑のset_line_food関数では@line_foodが生成されるので、それをDBに保存する
        if @line_food.save
          #保存できたら@line_foodをline_foodとして返してステータスもcreatedになる
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end  
      end

      #set_foodはline_food_controllerの中でしか呼ばれないからprivateにしておく
      private
      def set_food
        #Foodの中からfood_idで対応するFoodを取り出して、@ordered_foodというインスタンス変数に代入しておく
        @ordered_food = Food.find(params[:food_id])
      end

      #line_foodインスタンスを生成するための関数
      def set_line_food(ordered_food)
        #既にfoodに関するline_foodが存在する場合はpresentで判断する
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food
          #line_foodというインスタンス変数の情報を更新する
          @line_food.attributes = {
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          #全く新しいline_foodを作成する場合は、ordered_food.build_line_foodでインスタンスを新規作成する
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end
