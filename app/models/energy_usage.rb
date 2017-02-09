class EnergyUsage < ActiveRecord::Base
  belongs_to :building
  belongs_to :measurement
end