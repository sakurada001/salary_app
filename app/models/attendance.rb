require 'csv'

class Attendance < ApplicationRecord
  belongs_to :user

  # 夜勤（日またぎ）対応の計算ロジック
  def working_duration
    return "---" if start_time.nil? || end_time.nil?
    total_seconds = end_time - start_time
    total_seconds += 24.hours if total_seconds < 0
    work_seconds = total_seconds - (break_minutes.to_i * 60)
    work_seconds = 0 if work_seconds < 0

    hours = (work_seconds / 3600).to_i
    minutes = ((work_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end

  # CSV生成ロジック（必ず class の中に書く必要があります）
  def self.to_csv
    column_names = %w[勤務日 出勤 退勤 休憩 実労働時間 交通費]
    CSV.generate(headers: true) do |csv|
      csv << column_names
      all.each do |attendance|
        csv << [
          attendance.work_date,
          attendance.start_time&.strftime("%H:%M"),
          attendance.end_time&.strftime("%H:%M"),
          "#{attendance.break_minutes || 0}分",
          attendance.working_duration,
          "¥#{attendance.extra_travel_cost || 0}"
        ]
      end # all.each の終わり
    end # CSV.generate の終わり
  end # to_csv の終わり
end # Attendanceクラスの終わり（ここが抜けていたため、外にはみ出していました）