Rails.application.routes.draw do
  get "data/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "/product_data", to: "data#productIndex"
  get "/sales_data", to: "data#salesIndex"
  get "/notifications", to: "data#notifIndex"
  get "/ventas", to: "data#salesIndex"
  get "/ventas/totales", to: "total_sales#index"
  post "kafka/publish", to: "kafka#publish"
end
