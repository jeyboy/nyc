class FillMeasurements < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      [
          'Electricity Cost ($)',
          'Electricity Demand (KW)',
          'Electricity Usage (KWH)',
          'Gas (Therms)',
          'Gas Cost ($)',
          'Steam (mlbs)',
          'Total Usage (mmBTUs)'
      ].each do |name|
        Measurement.find_or_create_by!(name: name)
      end
    end
  end
end
