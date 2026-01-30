class AddColumnsToAttendances < ActiveRecord::Migration[8.1]
  def change
   # add_column :attendances, :break_minutes, :integer
    add_column :attendances, :extra_travel_cost, :integer
  end
end
