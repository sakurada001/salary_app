class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    # ユーザーのログインを確認する（ログインしていなければリダイレクト）
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to root_url, status: :see_other
      end
    end
end