Rails.application.routes.draw do
  # ルートをログイン画面に設定
  root   "sessions#new"

  # ログイン・ログアウト（Remember me に必須のルート）
  get    "/login",   to: "sessions#new"     # ログイン画面を明示的に定義
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy" # 本来はDELETEが推奨ですが、GETでも動きます
  get    "/logout",  to: "sessions#destroy" # GETでのログアウトも念のため残します

  # メイン機能
  get    "/home",    to: "static_pages#home"
  get    "/attendance", to: "static_pages#attendance", as: :attendance_form

  # ユーザー管理
  get    "/signup",  to: "users#new"
  post   "/signup",  to: "users#create"
  resources :users

  # 勤怠管理（重複を整理して1箇所にまとめました）
  resources :attendances do
    collection do
      post 'clock_in'
      post 'clock_out'
    end
  end
end