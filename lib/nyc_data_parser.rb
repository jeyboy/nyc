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

        measurement_id = measurements[row.delete('measurement')]

        name = row.delete('location_1_location')
        building = Building.find_or_create_by!(name: name)

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