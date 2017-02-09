class CreateMeasurement < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.string :name
    end
  end
end
