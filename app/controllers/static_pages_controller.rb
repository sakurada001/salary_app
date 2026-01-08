class StaticPagesController < ApplicationController
  # ホーム画面を表示する前に、ログインしているかチェックする
  before_action :logged_in_user

  def home
  end

  private

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to root_url, status: :see_other
      end
    end
end