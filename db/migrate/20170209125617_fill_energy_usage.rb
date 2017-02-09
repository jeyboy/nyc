require 'nyc_data_parser'

class FillEnergyUsage < ActiveRecord::Migration[5.0]
  def change
    NycDataParser.parse
  end
end
