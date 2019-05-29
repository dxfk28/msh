class AddCategoryToPlaceRecord < ActiveRecord::Migration[5.2]
  def change
  	add_column :place_records, :category, :string
  end
end
