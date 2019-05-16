class AddDepartmentToPlaceRecord < ActiveRecord::Migration[5.2]
  def change
  	add_column :place_records, :department, :string
  end
end
