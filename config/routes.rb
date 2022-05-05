Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :restaurants do
        #Foodはindexメソッドのみ
        resources :foods, only: %i[index]
      end
      #Line_Foodはindexとcreeateメソッドのみ
      resources :line_foods, only: %i[index create]
      #'line?foods/replace'というURLに対してPUTメソッドのリクエストが来たら、line_foods?controller.rbのreplaceメソッドを呼ぶ
      put 'line_foods/replace', to: 'line_foods#replace'
      #Orderはcreateメソッドのみ
      resources :orders, only: %i[create]
    end
  end
end
