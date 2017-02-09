class FillMeasurements < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      Measurement.find_or_create_by!(
        name: [
          'Electricity Demand (KW)',
          'Electricity Usage (KWH)',
          'Gas (Therms)',
          'Total Usage (mmBTUs)'
        ]
      )
    end
  end
end
