class StaticPagesController < ApplicationController
  # attendanceメソッドを実行する前に、必ずlogged_in_userを実行してチェックする
  before_action :logged_in_user, only: [:attendance]

  def home
  end

  def attendance
    # ここに到達する時は必ずログイン中なので、current_userはnilになりません
    @attendance = current_user.attendances.build
  end

  private

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        # root_url や login_url など、飛ばしたい先に合わせて調整してください
        redirect_to login_url, status: :see_other
      end
    end
end