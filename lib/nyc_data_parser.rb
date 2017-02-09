require 'rest-client'

class NycDataParser
  def self.parse
    response = RestClient::Request.execute(
      method: :get,
      url: 'https://data.cityofnewyork.us/resource/dnpn-ts5d.json'
    )
    json = JSON::parse(response.body)

    measurements = Measurement.all.each_with_object({}) {|measure, res| res[measure.name] = measure.id }

    ActiveRecord::Base.transaction do
      json.each do |row|
        next if row.empty?

        meas = row.delete('measurement')

        measurement_id = measurements[meas]
        unless measurement_id
          i = 0
        end

        location, name = row.delete('location_1_location').split(/ \[|\]/)
        building = Building.find_or_create_by!(name: name, location: location)

        row.to_a.each do |(key, val)|
          next if (key =~ /_|fy_/) == 0

          date = Date.strptime(key, '%b_%y')

          building.energy_usages.create!(
            measurement_id: measurement_id,
            year: date.year,
            month: date.month,
            amount: val.to_i
          )
        end
      end
    end
  end
end