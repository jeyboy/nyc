class Building < ActiveRecord::Base
  has_many :energy_usages
end