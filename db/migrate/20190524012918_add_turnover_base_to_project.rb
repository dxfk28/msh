class AddTurnoverBaseToProject < ActiveRecord::Migration[5.2]
  def change
  	add_column :projects, :turnover_base, :integer
  end
end
