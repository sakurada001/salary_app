class AttendancesController < ApplicationController
  before_action :logged_in_user

  # 1. 履歴一覧（CSV出力機能付き）
def index
    if current_user.is_admin?
      # 管理者の場合：全データを取得
      @attendances = Attendance.all.includes(:user).order(work_date: :desc)
    else
      # 一般ユーザーの場合：自分のデータのみ取得
      @attendances = current_user.attendances.order(work_date: :desc)
    end

    # 【重要】管理者・一般ユーザー問わず、人ごとにグループ化する
    # これによりビューの @grouped_attendances.each が正常に動きます
    @grouped_attendances = @attendances.group_by(&:user)

    # 祝日情報の取得（データが存在する場合のみ実行）
    @holidays = {}
    if @attendances.any?
      # データの範囲（一番古い日から一番新しい日まで）の祝日を取得
      start_date = @attendances.last.work_date
      end_date = @attendances.first.work_date
      
      HolidayJp.between(start_date, end_date).each do |h|
        @holidays[h.date.to_s] = h.name
      end
    end

    respond_to do |format|
      format.html # index.html.erb を表示
      format.csv do
        bom = "\xEF\xBB\xBF"
        csv_data = bom + @attendances.to_csv
        send_data csv_data, 
                 filename: "勤怠履歴_#{Date.current}.csv", 
                  type: 'text/csv; charset=utf-8'
      end
    end
  end

  # 2. 【ボタン用】出勤アクション
  def clock_in
    @attendance = current_user.attendances.build(
    work_date: Date.current, 
    start_time: Time.current
    )
    if @attendance.save
      render json: { status: 'success', start_time: @attendance.start_time }
    else
      render json: { status: 'error', message: '保存に失敗しました' }, status: :unprocessable_entity
    end
  end

  # 3. 【ボタン用】退勤アクション
  def clock_out
    # まだ退勤していない最新のデータを探す
    @attendance = current_user.attendances.where(end_time: nil).last
    
    if @attendance&.update(
      end_time: Time.current, 
      break_minutes: params[:break_minutes],
      extra_travel_cost: params[:extra_travel_cost] # ¥460などを保存
    )
      render json: { status: 'success' }
    else
      render json: { status: 'error', message: '保存に失敗しました' }, status: :unprocessable_entity
    end
  end

  # 4. 【手動入力用】フォームから送信されたデータを保存
  def create
    @attendance = current_user.attendances.build(attendance_params)
    if @attendance.save
      flash[:success] = "勤怠データを登録しました！"
      redirect_to attendances_path # 一覧画面へ移動
    else
      render 'static_pages/attendance', status: :unprocessable_entity
    end
  end

  private

    # 手動入力で受け取るデータを制限
    def attendance_params
      params.require(:attendance).permit(:work_date, :start_time, :end_time, :break_minutes, :extra_travel_cost)
    end

    # ログインしていない場合はログイン画面へ
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end
end