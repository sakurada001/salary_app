Rails.application.routes.draw do
  root   "sessions#new"
  post   "/login",   to: "sessions#create"
  get "/logout", to: "sessions#destroy"
  get    "/home",    to: "static_pages#home"

  # === ここを追加！ ===
  # signup_path という名前を使えるように設定します
  get  "/signup",  to: "users#new"
  post "/signup",  to: "users#create"
  # ユーザー一覧や登録実行のために必要
  resources :users
  # =====================

  # 給与明細や勤怠管理のルート（以前作成したものがあれば維持してください）
  get "/salary",     to: "static_pages#salary"
  get "/attendance", to: "static_pages#attendance"
end