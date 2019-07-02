class AddCloumnToPlaceRecord < ActiveRecord::Migration[5.2]
  def change
  	add_column :place_records, :mode, :string
  end
end
