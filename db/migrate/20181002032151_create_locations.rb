class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :full_address
      t.float :lat
      t.float :lng
      t.timestamps null: false
    end
  end
end
