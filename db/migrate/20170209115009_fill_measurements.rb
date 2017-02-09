class FillMeasurements < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      [
          'Electricity Demand (KW)',
          'Electricity Usage (KWH)',
          'Gas (Therms)',
          'Total Usage (mmBTUs)'
      ].each do |name|
        Measurement.find_or_create_by!(name: name)
      end
    end
  end
end
