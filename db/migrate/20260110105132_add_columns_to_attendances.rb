class AddColumnsToAttendances < ActiveRecord::Migration[7.0]
  def change
    # カラムが存在しない場合のみ追加するようにガードを入れます
    unless column_exists?(:attendances, :extra_travel_cost)
      add_column :attendances, :extra_travel_cost, :integer
    end

    # もし他にも追加しているカラムがあれば、同じように unless で囲んでください
    # 例：
    # unless column_exists?(:attendances, :another_column)
    #   add_column :attendances, :another_column, :string
    # end
  end
end