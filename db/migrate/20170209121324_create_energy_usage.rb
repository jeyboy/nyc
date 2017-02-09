class CreateEnergyUsage < ActiveRecord::Migration
  def change
    create_table :energy_usages do |t|
      t.references :building
      t.references :measurement
      t.integer :amount
      t.integer :year
      t.integer :month

      t.timestamps null: false
    end
  end
end