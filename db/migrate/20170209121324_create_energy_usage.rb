class CreateEnergyUsage < ActiveRecord::Migration
  def change
    create_table :energy_usages do |t|
      t.references :building
      t.references :measurement

      t.timestamps null: false
    end
  end
end