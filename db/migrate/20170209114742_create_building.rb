class CreateBuilding < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :location
    end
  end
end
