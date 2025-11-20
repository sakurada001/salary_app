Rails.application.routes.draw do
  # 2-1. ログインページ (最初の画面)
  root "static_pages#login"

  # 2-2. ホーム画面
  get "/home", to: "static_pages#home"

  # 2-3. 給与確認ページ
  get "/salary", to: "static_pages#salary"

  # 2-4. 勤怠管理ページ
  get "/attendance", to: "static_pages#attendance"

  # 2-5. ユーザー登録・変更ページ
  get "/users", to: "static_pages#user_management"
end