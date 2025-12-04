Rails.application.routes.draw do
  root "static_pages#login"

  # 静的ページ
  get "/home", to: "static_pages#home"
  get "/salary", to: "static_pages#salary"
  get "/attendance", to: "static_pages#attendance"

  # ユーザー登録用（ここを変更）
  get "/signup", to: "users#new"
  resources :users
end