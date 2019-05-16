class CreatePlaceRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :place_records do |t|
      t.integer :issue_id
      t.integer :user_id
      t.string :form
      t.string :to
      t.string :area
      t.string :province
      t.string :city

      t.timestamps
    end
  end
end
